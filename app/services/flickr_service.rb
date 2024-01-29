require 'byebug'

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

  def fetch_photos(api_method)
    consumer = OAuth::Consumer.new(@flickr_api_key, @flickr_api_secret, { site: FLICKR_API_URL })
    access_token = OAuth::AccessToken.new(consumer, @user.oauth_token, @user.oauth_token_secret)

  Rails.logger.debug(build_url(api_method))
    response = access_token.get(build_url(api_method))
  Rails.logger.debug(response)
    # return [] unless response.is_a?(Net::HTTPSuccess)
    begin
      json = JSON.parse(response.body)
      if json['stat'] == 'ok' && json['photos']
        json['photos']['photo'].map do |photo|
          {
            url: "https://live.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}_z.jpg",
            title: photo['title']
          }
        end
      else
        Rails.logger.error("API error: #{json['message']}")
        []
      end
    rescue JSON::ParserError => e
      Rails.logger.error("JSON parsing error: #{e.message}")
      []
    end
  end

  def fetch_contacts(api_method)
    consumer = OAuth::Consumer.new(@flickr_api_key, @flickr_api_secret, { site: FLICKR_API_URL })
    access_token = OAuth::AccessToken.new(consumer, @user.oauth_token, @user.oauth_token_secret)

  Rails.logger.debug(build_url(api_method))
    response = access_token.get(build_url(api_method))
  Rails.logger.debug(response)
    # return [] unless response.is_a?(Net::HTTPSuccess)

    begin
      json = JSON.parse(response.body)
  
      if json['stat'] == 'ok' && json['contacts']
        # Assuming 'contacts' is an array of contact objects
        json['contacts']['contact'].map do |contact|
          # Extract and return the desired information from each contact
          { username: contact['nickname'] }
        end
      else
        Rails.logger.error("Unexpected JSON structure: #{json}")
        []
      end
    rescue JSON::ParserError => e
      Rails.logger.error("JSON parsing error: #{e.message}")
      []
    end
  end

  private
  def build_url(api_method)
    uri = URI(FLICKR_API_URL)
    uri.query = URI.encode_www_form({
      method: api_method, 
      user_id: @user.uid, #CGI.escape(@user.uid),
      format: 'json',
      nojsoncallback: 1
    })
    uri.to_s
  end

end