class FlickrService
  require 'net/http'
  require 'json'

  FLICKR_API_URL = "https://api.flickr.com/services/rest/"

  def initialize(user_id)
    @user_id = user_id
    @flickr_api_key = Rails.application.credentials.flickr.api_key
    @flickr_api_secret = Rails.application.credentials.flickr.api_secret
  end

  def fetch_photos
    uri = URI(FLICKR_API_URL)
    
    uri.query = URI.encode_www_form({
      method: 'flickr.people.getPhotos',
      api_key: @flickr_api_key,
      user_id: @user_id,
      format: 'json',
      page: 1,
      nojsoncallback: 1
    })

    response = Net::HTTP.get_response(uri)
    return [] unless response.is_a?(Net::HTTPSuccess)

    json = JSON.parse(response.body)
    
    json['photos']['photo'].map do |photo|
      {
        url: "https://live.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}_z.jpg",
        title: photo['title']
      }
    end

  end

end