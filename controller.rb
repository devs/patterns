require "active_record"
require "filters"
require "erb"

class ControllerBase
  attr_accessor :request, :response

  def process(action)
    send action
  end
end

class Controller < ControllerBase
  include Filters
  
  def render(action)
    response.write render_to_string(action)
    @rendered = true
  end
  
  def rendered?
    @rendered
  end
  
  def render_to_string(action)
    path = template_path(action)
    ERB.new(File.read(path)).result(binding)
  end
  
  def template_path(action)
    File.dirname(__FILE__) + "/views/#{controller_name}/#{action}.erb"
  end
  
  def controller_name
    self.class.name[/^(\w+)Controller$/, 1].downcase # home
  end
end