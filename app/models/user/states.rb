class User
  acts_as_state_machine :initial => :active

  state :qctive,  :enter => :do_activate
  state :suspended
  state :deleted, :enter => :do_delete
  
  event :suspend do
    transitions :from => [:passive, :pending, :enabled], :to => :suspended, :guard => :remove_moderatorships
  end

  event :delete do
    transitions :from => [:passive, :pending, :enabled, :suspended], :to => :deleted
  end

  event :unsuspend do
    transitions :from => :suspended, :to => :enabled,  :guard => Proc.new {|u| !u.activated_at.blank? }
    transitions :from => :suspended, :to => :pending, :guard => Proc.new {|u| !u.activation_code.blank? }
    transitions :from => :suspended, :to => :passive
  end

  protected
  def do_delete
    self.deleted_at = Time.now.utc
  end
  
  def do_activate
    @activated = true
    self.deleted_at = nil
  end
  
  def remove_moderatorships
    moderatorships.delete_all
  end
end
