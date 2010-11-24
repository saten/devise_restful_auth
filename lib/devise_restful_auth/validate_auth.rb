module DeviseRestfulAuth
  def self.included(base)
    base.send :extend, ClassMethods
  end
 
  module ClassMethods
    # any method placed here will apply to classes, like Hickwall
    def acts_as_yaffle(options = {})
      send :include, InstanceMethods
    end
  end
 
  module InstanceMethods
    # any method placed here will apply to instaces, like @hickwall
    def squawk(string)
    end
  end
  ActionController::Base.send(:include,DeviseRestfulAuth)
end
