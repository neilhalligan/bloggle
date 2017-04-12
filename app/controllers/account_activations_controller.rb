class AccountActivationsController < ApplicationController
  def edit
    activation_token = params[:id]
    user = User.find_by(email: params[:email])
    if user && user.authenticated?(:activation, activation_token)
      user.activate
      flash[:success] = "Account authenticated successfully"
      log_in(user)
      redirect_to user
    else
      flash[:danger] = "Activation link invalid"
      redirect_to root_path
    end
  end
end

