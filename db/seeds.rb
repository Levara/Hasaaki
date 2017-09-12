# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
images = {}
files = Dir.glob("public/imageclinic/**/*")
#Dir.glob("public/data/*").sort.each do |path|
files.sort.each do |path|
  unless File.directory?(path) 
    filetype = `file #{path}`
    if filetype.split(" ")[1].eql? "JPEG" 
      image = path.sub(/\._original$/, "")
      images[image] = {} if images[image].nil?

      if image.eql? path
        images[image][:short] = path
      else
        images[image][:long] = path
      end

    end
  end
end

puts "Loading images"
images.each do |key, image|
  if image[:long].nil?
    original = image[:short]
    optimized = nil
  else
    original = image[:long]
    optimized = image[:short]
  end

  imgdata = {}
  imgdata[original] = `identify -format "%[fx:w] %[fx:h] %b" #{original}`.split(" ")
  imgdata[optimized] = `identify -format "%[fx:w] %[fx:h] %b" #{optimized}`.split(" ") unless optimized.nil?

  newimg = Image.new
  newimg.optimized = optimized.nil? ? 0 : 1

  newimg.original_path = original[6..-1]
  newimg.original_width = imgdata[original][0].to_i
  newimg.original_height = imgdata[original][1].to_i
  newimg.original_size = imgdata[original][2].to_i

  newimg.optimized_path = optimized[7..-1] unless optimized.nil?
  newimg.optimized_width = imgdata[optimized][0].to_i unless optimized.nil?
  newimg.optimized_height = imgdata[optimized][1].to_i unless optimized.nil?
  newimg.optimized_size = imgdata[optimized][2].to_i unless optimized.nil?

  newimg.save

  putc "."
end
puts "\nAll is well and done and saved!"
