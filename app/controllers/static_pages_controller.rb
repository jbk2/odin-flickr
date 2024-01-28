class StaticPagesController < ApplicationController
  # before_action :authenticate_user!
  def home
    if params[:flickr_user_id]
      @user = current_user
      @photos = fetch_photos
    end
    
    if params[:uid]
      @user = current_user
      @contacts = fetch_contacts_for(@flickr_user_id)
    end
  end

  private
  def fetch_photos_for(flickr_user_id)
    flickr_service = FlickrService.new(flickr_user_id)
    @photos = flickr_service.fetch_photos
  end
  
  def fetch_contacts
    flickr_service = FlickrService.new(current_user)
    @contacts = flickr_service.fetch_contacts
  end

  def static_page_params
    params.require(:static_page).permit(:flickr_user_id)
  end
end
