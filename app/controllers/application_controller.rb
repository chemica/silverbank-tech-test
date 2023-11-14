# frozen_string_literal: true

# Base controller class
class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers

  helper_method :current_user

  private

  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  def require_user!
    return if current_user

    save_passwordless_redirect_location!(User)
    redirect_to new_user_path, flash: { error: 'Please sign in or register an account' }
  end
end
