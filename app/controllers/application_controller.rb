# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  helper_method :current_page
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :update, :destroy]
  before_filter :set_mailer_url_options
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e125a4be589f9d81263920581f6e4182'

  # raised in #current_site
  rescue_from Site::UndefinedError do |e|
    redirect_to new_site_path
  end

  def current_page
    @page ||= [1, params[:page].to_i].max
  end

  private

  def set_mailer_url_options
    ActionMailer::Base.default_url_options[:host] = current_site.host
  end
end
