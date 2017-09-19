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
    @images = Image.all
    @images.each do |image|
      image = Image.find(image.id)
      if image.optimized == 0
        break
      end
      RevertImageJob.perform_later(image) unless image.nil?
    end
    redirect_to root_path, notice: "Reverting image", class: "important"
  end

  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      format.js { render :show }
    end
  end
    

end
