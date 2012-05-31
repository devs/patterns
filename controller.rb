require "active_record"
require "filters"

class Controller
  attr_accessor :request, :response
  
  include Filters
end