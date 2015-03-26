class ApplicationController < ActionController::Base
	  before_action :configure_devise_permitted_parameters, if: :devise_controller?

	  protected

	  def configure_devise_permitted_parameters
    	devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :user_type, :license_num, :care_card_num, :pharmacy_address, :password_confirmation) }
    	devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :user_type, :license_num, :care_card_num, :pharmacy_address, :password_confirmation) }
	  end


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
