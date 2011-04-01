class UsersController < ApplicationController
  def new
    @user = User.new
    @title = "Signup"
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # Handle a successful save.
      flash[:success] = "Wassup yo"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end
end
