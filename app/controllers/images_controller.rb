class ImagesController < ApplicationController

  def index
    @images = Image.all

  end

  def optimize_single_jpeg(*args)
    image = Image.find(params[:image_id])
    # ruby does not have global scope by default
    # https://stackoverflow.com/a/34655466
    OptimizeSingleJpegJob.perform_now(image) unless image.nil?
		redirect_to root_path, notice: "Image optimization started."
  end
    

end
