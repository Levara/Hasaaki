class OptimizeSingleJpegJob < ActiveJob::Base
	queue_as :urgent

  after_perform :notify

	def perform(*args)
    image = args[0]
    puts image.original_path
	end

  def notify
    puts "notify"

  end

    #
    #
    #
		#puts "Started rescaning of images folder!!!!"
		#image_log = []
		#count = 0
		#files = Dir.glob("public/cellimages/**/*")
		#files.each do |file|
			#if File.file?(file)
				#digest = Digest::SHA1.hexdigest(File.read(file))
				#path = file.sub(/^public/, "")

				#puts path, digest
				#if Image.where(digest: digest).empty?
					#image = Image.new
					#image.path = path
					#image.digest = digest
					#wh = `identify -format "%wx%h" #{file}`
					#w, h = wh.split('x')

					#image.width = w
					#image.height = h
					#if image.save
						#image_log << "Status 1: Image #{file} added to database"
						#count += 1
					#else
						#image_log << "Status 2: Image #{file} NOT added to database"
					#end
				#else
					#image_log << "Status 3: Image #{file} already in database"
				#end
			#end
		#end
		#puts image_log

		#if count != 0
			#User.where(approved: true).each do |user|
				#user.notify_user("#{count} new #{"image".pluralize(count)} added to database.")
			#end
		#end
end
