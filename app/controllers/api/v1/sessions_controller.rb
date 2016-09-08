class Api::V1::SessionsController < ApplicationController

  def create
    # TODO: add begin/rescue/end
    user = User.find_by(email: params[:session][:email])

    if user.valid_password?(params[:session][:password])
      sign_in(user, store: false)
      user.generate_authentication_token!
      user.save
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end
end
