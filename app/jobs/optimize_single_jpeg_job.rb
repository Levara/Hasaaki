class OptimizeSingleJpegJob < ActiveJob::Base
	queue_as :urgent

  after_perform :notify

	def perform(*args)
    image = args[0]
    origpath = get_origpath image
    optipath = get_optipath image
    if optipath.nil?
      workpath, quality = optimize(origpath)
      save_optimized(image, workpath, quality)
    end

	end

  def save_optimized(image, workpath, quality)
    abs_old_path = get_origpath image
    abs_new_path = abs_old_path.to_s + "._original"
    abs_opt_path = abs_old_path


    rel_orig = image.original_path.to_s + "._original"
    rel_opti = image.original_path.to_s

    `cp "#{abs_old_path}" "#{abs_new_path}"`
    `cp "#{workpath}/optimized.jpg" "#{abs_opt_path}"`
    `rm -rf "#{workpath}"`

    optimized_data = `identify -format "%[fx:w] %[fx:h] %b" #{abs_opt_path}`.split(" ")
    image.optimized_width =  optimized_data[0].to_i
    image.optimized_height = optimized_data[1].to_i
    image.optimized_size =   optimized_data[2].to_i

    image.original_path = rel_orig
    image.optimized_path = rel_opti
    image.optimized = 1
    image.quality = quality
    image.encoder = "mozjpeg"

   
    image.save


  end

  def optimize(origpath)

    puts "Copy orig file"
    digest = Digest::SHA1.hexdigest(File.read(origpath))
    workpath = "/ramdisk/#{digest}"
    `mkdir "#{workpath}"`
    `cp "#{origpath}" "#{workpath}/original.jpg"`

    #TESTING
    #`convert -quality 98 -resize '1920x>'  "#{workpath}/original.jpg" "#{workpath}/original.jpg"`
    #`convert -quality 98 -resize '920x>'  "#{workpath}/original.jpg" "#{workpath}/original.jpg"`

    puts "Convert to png"
    `convert -quality 1 "#{workpath}/original.jpg" "#{workpath}/original.png"`

    iter = 1
    qlow = 10
    qhigh = 90
    dssim_low = 0.0038
    dssim_high  = 0.0042
    dssim_avg  = (dssim_high - dssim_low) / 2.0


    dssim = 1
    while (dssim < dssim_low or dssim > dssim_high) and iter<7
      q = (qhigh + qlow) /2 
      puts "Iteration #{iter}"
      puts "High #{qhigh}, Low #{qlow}, Q #{q}"
      `~/mozjpeg/build/cjpeg -quality #{q} "#{workpath}/original.jpg" > "#{workpath}/#{q}.jpg"`
      `convert -quality 1 "#{workpath}/#{q}.jpg" "#{workpath}/#{q}.png"`
      dssim = `~/dssim/bin/dssim "#{workpath}/original.png" "#{workpath}/#{q}.png"`
      dssim =  dssim.split(" ")[0].to_f
      puts "DSSIM: #{dssim}"
      if dssim > dssim_high
        qlow = q+1
        #q += 10
      elsif dssim < dssim_low
        qhigh = q-1
        #q -= 10
      end

      iter += 1
    end

    `mv "#{workpath}/#{q}.jpg" "#{workpath}/optimized.jpg"`

    return [ workpath, q ]
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
