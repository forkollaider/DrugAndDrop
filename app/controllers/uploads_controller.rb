class UploadsController < ApplicationController
  def index
    @upload = Upload.new
  end

  def create
    @upload = Upload.new(upload_params)
    if @upload.save
      render json: { message: "success", uploadId: @upload.id}, status: 200
      @new_image = Cloudinary::Uploader.upload(@upload.image.path)
      @upload.url = @new_image["secure_url"]
      @upload.url_original = @new_image["secure_url"]
      @upload.user_id = current_user.id
      @upload.public_id = @new_image["public_id"]
      @upload.save
    else
      render json: { error: @upload.errors.full_messages.join(", ") }, status: 400
    end
  end

  def list
    uploads = []
    current_user.uploads.each do |upload|
      new_upload = {
          id: upload.id,
          name: upload.image_file_name,
          size: upload.image_file_size,
          src: upload.url,
          public_id: upload.public_id
      }
      uploads.push(new_upload)
    end
    render json: {images:uploads}
  end

  def show
  @upload = Upload.find(params[:id])
  end

  def destroy
    @upload = Upload.find(params[:id])
    Cloudinary::Uploader.destroy(@upload.public_id)
    if @upload.destroy
      render json: { message: "file deleted from server"}
    else
      render json: { message: @image.errors.full_message.join()}
    end
  end


  def update
    @upload = Upload.find_by(public_id:params[:id])
    @upload.url = params[:url]
    @upload.save
    redirect_to uploads_path
  end

  private

  def upload_params
    params.require(:upload).permit(:image)
  end
end
