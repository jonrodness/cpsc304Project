class ApplicationController < ActionController::Base
	  require "#{Rails.root}/lib/exceptions.rb"
	  #rescue_from ActiveRecord::StatementInvalid, :with => :error_statement_invalid
	  rescue_from Exceptions::AssertionError, :with => :error_assertion_error
	  before_action :configure_devise_permitted_parameters, if: :devise_controller?

	  protected

	  def configure_devise_permitted_parameters
    	devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :user_type, :license_num, :care_card_num, :pharmacy_address, :password_confirmation) }
    	devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :user_type, :license_num, :care_card_num, :pharmacy_address, :password_confirmation) }
	  end

	  def error_statement_invalid
	  	#@result = Table.connection.select_all("select * from Drug")
	  	redirect_to tables_path, :flash => { :alert => "Your request could not be completed. Please make sure the fields are filled out correctly and that your query does not violate any foreign key constraints."}
	  end

	  def error_assertion_error
	  	redirect_to tables_path, :flash => { :alert => "Your request could not be completed. Please make sure the fields are filled out correctly."}
	  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
