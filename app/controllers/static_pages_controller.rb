class StaticPagesController < ApplicationController
  before_action :authenticate_user!
  def home
    if params[:uid] && (params[:api_method] == "fetch_photos")
      puts "******* params were fetch_photos and uid ************"
      @photos = fetch_photos("flickr.people.getPhotos")
      Rails.logger.debug(@photos)
    end
    
    if params[:uid] && (params[:api_method] == "fetch_contacts")
      puts "******* params were fetch_contacts and uid ************"
      @contacts = fetch_contacts('flickr.contacts.getList')
      Rails.logger.debug(@contacts)
    end
  end

  private
  def fetch_photos(api_method)
    flickr_service = FlickrService.new(current_user)
    flickr_service.fetch_photos(api_method)
  end
  
  def fetch_contacts(api_method)
    flickr_service = FlickrService.new(current_user)
    @contacts = flickr_service.fetch_contacts(api_method)
  end

  def static_page_params
    params.require(:static_page).permit(:uid, :username, :api_method)
  end
end
