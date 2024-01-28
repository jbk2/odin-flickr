require 'pp'

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default("")
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  flickr_user_id         :string
#  provider               :string
#  uid                    :string
#  oauth_token            :string
#  oauth_token_secret     :string
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:flickr]
  
  def self.from_omniauth(auth)
    Rails.logger.debug("OmniAuth Auth Hash: #{auth.pretty_inspect}")
    Rails.logger.debug("OmniAuth Auth Token: #{auth.credentials.token.pretty_inspect}")
    Rails.logger.debug("OmniAuth Auth Secret: #{auth.credentials.secret.pretty_inspect}")
    
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.username = auth.info.nickname
      user.password = Devise.friendly_token[0, 20]
      user.oauth_token = auth.credentials.token
      user.oauth_token_secret = auth.credentials.secret
    end
    if user.new_record?
      if user.valid?
        user.save!
      else
        Rails.logger.debug("User could not be saved: #{user.errors.full_messages}")
      end
    end
    user
  end

end
