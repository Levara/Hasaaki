class ImagesController < ApplicationController

  def index
    @images = Image.all

  end

  def optimize_single_jpeg(*args)
    @images = Image.all
    @images.each do |image|
      image = Image.find(image.id)
      if image.optimized == 0
        OptimizeSingleJpegJob.perform_later(image) unless image.nil?
      end
    end
    redirect_to root_path, notice: "Image optimization started."
  end

  def revert_image(*args)
    image = Image.find(params[:image_id])
    if image.optimized == 0
      redirect_to root_path, notice: "Nothing to revert"
    else
      RevertImageJob.perform_later(image) unless image.nil?
      redirect_to root_path, notice: "Reverting image", class: "important"
    end
  end

  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      format.js { render :show }
    end
  end
    

end
