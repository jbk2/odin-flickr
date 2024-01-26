class FlickrService
  require 'net/http'
  require 'json'
  require 'oauth'

  FLICKR_API_URL = "https://api.flickr.com/services/rest/"

  def initialize(user)
    @user = user
    @flickr_api_key = Rails.application.credentials.flickr.api_key
    @flickr_api_secret = Rails.application.credentials.flickr.api_secret
  end

  def fetch_photos
    # Construct the OAuth consumer and access token
    consumer = OAuth::Consumer.new(@flickr_api_key, @flickr_api_secret, { site: FLICKR_API_URL })
    access_token = OAuth::AccessToken.new(consumer, @user.oauth_token, @user.oauth_token_secret)

    # Make the request
    response = access_token.get(build_url)
    return [] unless response.is_a?(Net::HTTPSuccess)

    json = JSON.parse(response.body)
    json['photos']['photo'].map do |photo|
      {
        url: "https://live.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}_z.jpg",
        title: photo['title']
      }
    end
  end

  private
  def build_url
    # Build URL with query parameters
    uri = URI(FLICKR_API_URL)
    uri.query = URI.encode_www_form({
      method: 'flickr.people.getPhotos',
      user_id: @user.flickr_user_id,  # Assuming this is stored in the user model
      format: 'json',
      nojsoncallback: 1
    })
    uri.to_s
  end

end