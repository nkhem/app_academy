class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])

    if @user
      login(@user)
      redirect_to new_user_url
    else
      flash[:errors] = ["Invalid username or password"]
      render :new
    end
  end

  def destroy
    logout if current_user
    redirect_to new_session_url
  end
end
