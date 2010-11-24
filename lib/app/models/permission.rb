class Permission < ActiveRecord::Base
  has_many :subject_permissions
  has_many :user_society_roles
  
  validates_uniqueness_of :controller,:scope =>:action
  
  def name
    "#{id} - #{controller}/#{action}"
  end
end
