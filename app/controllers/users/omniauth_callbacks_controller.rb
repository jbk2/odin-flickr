class Users::OmniauthCallbacksController < ApplicationController

  def flickr
    # Here you handle the callback from Flickr
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.flickr_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    # handle failure
    redirect_to root_path
  end
end
