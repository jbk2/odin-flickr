class Users::OmniauthCallbacksController < ApplicationController

  def flickr
    Rails.logger.debug
    # Here you handle the callback from Flickr
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication, notice: "user was persisted and signed in"
    else
      session["devise.flickr_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, notice: "user not created"
    end
  end


  def failure
    # handle failure
    redirect_to root_path
  end
end
