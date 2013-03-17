namespace :parse do
  desc "Parse all video XMLs in directory"
  task :videos, [:dir_name] => [:environment] do |t, args|
    puts args.to_yaml
    dir_name = args[:dir_name] || args['dir_name']
    raise Exception, "File not found: #{args}" unless File.exists?(dir_name)

    # Find all the files we want to match in the system ...
    file_names = [Dir["#{dir_name}/*.m4v"], Dir["#{dir_name}/*.mp4"], Dir["#{dir_name}/*.xml"]].flatten
    file_names.reject! do |file_name|
      (file_name.end_with?('.mp4') || file_name.end_with?('.m4v')) &&
      File.exists?(file_name[0..-5] + '.xml') ||
      File.basename(file_name) == 'sample.xml'
    end
    file_names.sort!
    puts '-' * 10
    file_names.each do |file_name|
      puts file_name
      Rake::Task['parse:video'].execute :file_name => file_name
    end
    puts '=' * 10
  end

  desc "Parse a video XML file"
  task :video, [:file_name] => [:environment] do |t, args|
    file_name = args[:file_name] || args['file_name']
    raise Exception, "File not found: #{args}" unless File.exists?(file_name)

    require 'fileutils'
    jpg_name = file_name[0..-5]+'.jpg'
    xml_name = file_name[0..-5]+'.xml'
    video    = Video.find_or_create_by_file_name(:file_name => xml_name)
    video.save

    if (file_name.end_with?('.mp4') || file_name.end_with?('.m4v'))
      video.title = File.basename(file_name)[0..-5]
    elsif (file_name.end_with?('.xml'))
      doc = Nokogiri::XML(open(file_name))

      args = {}
      [
        :title,
        :genre,
        :mpaa,
        :director,
        :actors,
        :description,
        :year,
        :length,
        :netflix,
      ].each do |field|
        args[field] = (doc.css(field.to_s).first.text rescue nil)
      end
      args[:year]   = (args.delete(:year).to_i rescue nil)
      args[:year] = nil if args[:year].nil? || args[:year] == 0
      args[:length] = (args.delete(:length).to_i rescue nil)
      args[:length] = nil if args[:length].nil? || args[:length] == 0
      args[:actors] = (args.delete(:actors).split(',').collect { |name| name.strip!; Actor.find_or_create_by_name(:name => name) } rescue [])
      args[:director] = (args.delete(:director).split(',').collect { |name| name.strip!; Director.find_or_create_by_name(:name => name) } rescue [])
      args[:genres] = (args.delete(:genre).split(',').reject { |name| name.include?('Actors/') || name.include?('Directors/')}.collect  { |name| name.strip!; Genre.find_or_create_by_name(:name => name) } rescue [])

      video.title       = args[:title]
      video.year        = args[:year]
      video.length      = args[:length]
      video.year        = args[:year]
      video.mpaa        = args[:mpaa]
      video.actors      = args[:actors]
      video.genres      = args[:genres]
      video.description = args[:description]
      video.netflix_url = args[:netflix]
    end
    video.save

    # puts ""
    # puts video.to_yaml
    tmp_file = File.join(Rails.root, 'public', 'tmp', "video-#{video.id}.jpg")
    FileUtils.rm(tmp_file, :verbose => true) if File.exists?(tmp_file)
    FileUtils.cp(jpg_name, tmp_file, :verbose => true) if File.exists?(jpg_name)
  end
end

namespace :writers do
  desc "Output all video XMLs into a directory"
  task :videos, [:dir_name] => [:environment] do |t, args|
    puts args.to_yaml
    dir_name = args[:dir_name] || args['dir_name']
    raise Exception, "File not found: #{args}" unless File.exists?(dir_name)

    puts '-' * 10
    Video.all.select { |video| video.file_name.start_with?(dir_name) }.collect { |video| video.file_name }.sort.each do |file_name|
      puts file_name
      Rake::Task['writers:video'].execute :file_name => file_name
    end
    puts '=' * 10
  end

  desc "Output a video XML into a directory"
  task :video, [:file_name] => [:environment] do |t, args|
    # puts args.to_yaml
    file_name = args[:file_name] || args['file_name']
    raise Exception, "File not found: #{args}" unless File.exists?(File.dirname(file_name))

    video = Video.find_by_file_name(file_name)
    raise Exception, "Video not found: #{args}" if video.nil?

    output = {
      :title => video.title,
      :year  => (video.year || '').to_s,
      :length => (video.length || '').to_s,
      :mpaa  => video.mpaa,
      :description  => video.description,
      :netflix_url  => video.netflix_url,
      :director  => video.directors.collect { |value| value.name }.join(', '),
      :actors  => video.actors.collect { |value| value.name }.join(', '),
      :genre  => [video.genres.collect { |value| value.name }, video.actors.collect { |value| "[Actors/#{value.name}]" }].flatten.join(', '),
    }

    output = output.to_xml(:root => 'video')
    # puts output
    File.open(file_name, 'w') { |f| f.write output }
  end
end
