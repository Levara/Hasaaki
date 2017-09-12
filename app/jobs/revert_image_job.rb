class RevertImageJob < ActiveJob::Base
	queue_as :urgent

  after_perform :notify

	def perform(*args)
    image = args[0]
    origpath = get_origpath image
    optipath = get_optipath image

    puts origpath
    puts optipath

    `cp "#{origpath}" "#{optipath}"`
    `rm "#{origpath}" `
    puts image.original_path
    puts image.optimized_path
    image.original_path = image.optimized_path.to_s
    image.optimized = 0
    image.optimized_path = nil
    image.optimized_width =  nil
    image.optimized_height = nil
    image.optimized_size =   nil
    image.save

	end

  def get_origpath(image)
    Rails.root.join("public", image.original_path[1..-1])
  end

  def get_optipath(image)
    Rails.root.join("public", image.optimized_path[1..-1]) unless image.optimized_path.nil?
  end



  def notify
    puts "notify"

  end
end
