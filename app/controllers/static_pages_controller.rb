class StaticPagesController < ApplicationController
  def home

  end

  def flickr_users_images
    @flickr_user_id = params[:flickr_user_id]
    flickr_service = FlickrService.new(@flickr_user_id)
    @photos = flickr_service.fetch_photos

    render 'home'
  end

  private
  def static_page_params
    params.require(:static_page).permit(:flickr_user_id)
  end
end
