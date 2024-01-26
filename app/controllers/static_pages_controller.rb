class StaticPagesController < ApplicationController
  def home
    if params[:flickr_user_id]
      @flickr_user_id = params[:flickr_user_id]
      @photos = fetch_photos_for(@flickr_user_id) # Implement this method to fetch photos
    end
  end

  private
  def fetch_photos_for(flickr_user_id)
    flickr_service = FlickrService.new(flickr_user_id)
    @photos = flickr_service.fetch_photos
  end

  def static_page_params
    params.require(:static_page).permit(:flickr_user_id)
  end
end
