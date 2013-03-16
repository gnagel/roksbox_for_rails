namespace :parse do
  desc "Parse all video XMLs in directory"
  task :videos, [:dir_name] => [:environment] do |t, args|
    puts args.to_yaml
    dir_name = args[:dir_name] || args['dir_name']
    raise Exception, "File not found: #{args}" unless File.exists?(dir_name)
    
    Dir["#{dir_name}/*.xml"].each do |file_name|
      puts '-' * 10
      puts ''
      puts file_name
      puts ''
      Rake::Task['parse:video'].execute :file_name => file_name
      puts ''
      puts '=' * 10
    end
  end

  desc "Parse a video XML file"
  task :video, [:file_name] => [:environment] do |t, args|
    puts args.to_yaml
    file_name = args[:file_name] || args['file_name']
    raise Exception, "File not found: #{args}" unless File.exists?(file_name)
    
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
      :length
      ].each do |field| 
        args[field] = doc.css(field.to_s).first.text
    end
    args[:year]   = (args.delete(:year).to_i rescue nil)
    args[:length] = (args.delete(:length).to_i rescue nil)
    args[:actors] = (args.delete(:actors).split(',').collect { |name| name.strip!; Actor.find_or_create_by_name(:name => name) } rescue [])
    args[:genres] = (args.delete(:genre).split(',').collect  { |name| name.strip!; Genre.find_or_create_by_name(:name => name) } rescue [])

    video = Video.find_or_create_by_title_and_year(:title => args[:title], :year => args[:year])
    video.mpaa   = args[:mpaa]
    video.actors = args[:actors]
    video.genres = args[:genres]
    video.save
  end
end
