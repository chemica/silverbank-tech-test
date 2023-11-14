# frozen_string_literal: true

# Controller for the User model
class UsersController < ApplicationController
  before_action :require_user!, only: %i[show]

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to auth_sign_in_url, notice: 'Your account is ready. Please log in.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:display_name, :email, :account_name)
  end
end
