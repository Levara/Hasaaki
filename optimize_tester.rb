#digest = Digest::MD5.hexdigest(File.read(Rails.root.join("app/jobs/optimize_single_jpeg_job.rb")))
digest = "a"
while 1 do
  `sleep 1`
  newdigest = Digest::MD5.hexdigest(File.read(Rails.root.join("app/jobs/optimize_single_jpeg_job.rb")))
  if not newdigest.eql? digest
    load(Rails.root.join("app/jobs/optimize_single_jpeg_job.rb"))
    puts "Running file"
    begin
      OptimizeSingleJpegJob.perform_now(Image.first)
    rescue => e
      puts e.message
    end
    digest = newdigest
  end
end
