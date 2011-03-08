require 'spec_helper'

describe UsersController do
	render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

  	it "should have the right title" do
      get 'new'
      response.should have_selector("title",
					:content => "Sign up")
    end
  end

	decribe "GET 'show'" do

		before(:each) do
			User.create!({:name => "Sample User", :email => "sample@user.com"})
		end

		it "should be successful" 

end
