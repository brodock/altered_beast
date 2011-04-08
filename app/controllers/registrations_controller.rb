class RegistrationsController < Devise::RegistrationsController
  
   def build_resource(hash=nil)
    hash ||= params[:user] || {}
    self.resource = User.new(hash)
    self.resource.site_id = current_site.id
  end
end