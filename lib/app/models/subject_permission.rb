class SubjectPermission < ActiveRecord::Base
  belongs_to :subject, :polymorphic=>true
  belongs_to :item, :polymorphic => true
  belongs_to :permission
  validates_presence_of :subject,:scope=>[:item_type,:permission]
end
