class WelcomeController < ApplicationController

def index
  render json: {message: "Please use /get_reviews route & add parameter of your lending link string for output"}
end

end
