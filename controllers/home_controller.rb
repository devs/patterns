class HomeController < Controller
  def index
    response.write "Hi from from home controller."
  end
  
  def nice
    response.write "This is nice!"
  end
end