module AuthenticatedSystem
  protected
    def current_site
      @current_site ||= Site.find_by_host(request.host.dup) or raise Site::UndefinedError
    end

    def admin?
      user_signed_in? && current_user.admin?
    end
    
    def moderator_of?(record)
      return true if admin?
      return false unless user_signed_in?
      forum = record.respond_to?(:forum) ? record.forum : record
      current_user.moderator_of? forum
    end

    def admin_required
      flash[:error] = "Access denied for non admin users"
      admin? || authenticate_user!
    end

    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.fullpath
    end

    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.  Set an appropriately modified
    #   after_filter :store_location, :only => [:index, :new, :show, :edit]
    # for any controller you want to be bounce-backable.
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    # Inclusion hook to make #current_user and #current_site
    # available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_user, :current_site, :admin?, :moderator_of? if base.respond_to? :helper_method
    end

end
