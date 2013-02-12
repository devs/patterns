require "models/user"

class UsersController < Controller
  def index
    User.all.each do |user|
      response.write "<p>#{user.name}</p>"
    end
  end
  
  def show
    user = User.find(params["id"])
    response.write "<p>#{user.name}</p>"
  end
end