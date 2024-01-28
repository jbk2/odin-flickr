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
    response = access_token.get(build_get_photos_url)
    return [] unless response.is_a?(Net::HTTPSuccess)

    json = JSON.parse(response.body)
    json['photos']['photo'].map do |photo|
      {
        url: "https://live.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}_z.jpg",
        title: photo['title']
      }
    end
  end

  def fetch_contacts
    consumer = OAuth::Consumer.new(@flickr_api_key, @flickr_api_secret, { site: FLICKR_API_URL })
    access_token = OAuth::AccessToken.new(consumer, @user.oauth_token, @user.oauth_token_secret)

    # Make the request
    response = access_token.get(build)
    return [] unless response.is_a?(Net::HTTPSuccess)

    json = JSON.parse(response.body)
    Rails.logger.debug json.inspect
    @contacts = json['contacts']['contact']
  end

  private
  def build_get_photos_url
    # Build URL with query parameters
    uri = URI(FLICKR_API_URL)
    uri.query = URI.encode_www_form({
      method: 'flickr.people.getPhotos',
      user_id: @user.uid,
      format: 'json',
      nojsoncallback: 1
    })
    uri.to_s
  end
 
  def build_get_contacts_url
    # Build URL with query parameters
    uri = URI(FLICKR_API_URL)
    uri.query = URI.encode_www_form({
      method: 'flickr.contacts.getList',
      user_id: @user.uid,
      format: 'json',
      nojsoncallback: 1
    })
    uri.to_s
  end

end