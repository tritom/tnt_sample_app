class PagesController < ApplicationController
  def home
    @title = "Home"
  end

  def contact
    @title = "Contact"
  end
  
  def about
    @title = "About"
  end

	def help
		if params[:id]
		@title = params[:id]
		else
		@title = "Help"
		end
	end
end
