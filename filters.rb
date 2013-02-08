module Filters
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def before_filter(method)
      around_filter do |controller, action|
        controller.send method
        action.call
      end
    end
    def after_filter(method)
      around_filter do |controller, action|
        action.call
        controller.send method
      end
    end
    def around_filters
      @around_filters ||= []
    end
    def around_filter(method=nil, &block)
      if block
        around_filters << block
      else
        around_filters << proc { |controller, action| controller.send method, &action }
      end
    end
  end
  
  def process(action)
    # before_filter :one
    # after_filter :two
    #
    # proc do
    #   one
    #   proc do
    #     proc { super }.call
    #     two
    #   end.call
    # end.call

    self.class.around_filters.reverse.inject(proc { super }) do |parent_proc, filter|
      proc { filter.call(self, parent_proc) }
    end.call
  end
  
  
  ###### Using ActiveSupport::Callbacks ######
  # extend ActiveSupport::Concern
  
  # included do
  #   include ActiveSupport::Callbacks
  #   define_callbacks :process
  # end
  
  # module ClassMethods
  #   def before_filter(method)
  #     set_callback :process, :before, method
  #   end
  #   def after_filter(method)
  #     set_callback :process, :after, method
  #   end
  #   def around_filter(method)
  #     set_callback :process, :around, method
  #   end
  # end
  
  # def filter
  #   run_callbacks :process do
  #     yield
  #   end
  # end
end