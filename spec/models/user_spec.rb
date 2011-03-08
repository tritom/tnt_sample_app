require 'spec_helper'

describe User do

	before(:each) do
		@attr = { :name => "Example User", :email => "user@example.com" }
	end

	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end
	
	it "should require a name" do
		no_name_user = User.new(@attr.merge(:name => ""))
		no_name_user.should_not be_valid
	end

	it "should require an email" do
		no_email_user = User.new(@attr.merge(:email => ""))
		no_email_user.should_not be_valid
	end

	it "should reject names that are too long" do
		long_name = "a" * 51
		long_name_user = User.new(@attr.merge(:name => long_name))
		long_name_user.should_not be_valid
	end

	it "should accept valid emails" do
		addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
		addresses.each do |address|
			user = User.new(@attr.merge(:email => address))
			user.should be_valid
		end
	end
	
	it "should reject invalid emails" do
		invalid_addresses = %w[ user@foo,com foo_bar.com first.last@foo. ]
		invalid_addresses.each do |invalid_address|
			user = User.new(@attr.merge(:email => invalid_address))
			user.should_not be_valid
		end
	end

	it "should reject duplicate email adresses" do
		User.create!(@attr)
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.should_not be_valid
	end
	
	it "should reject duplicate email adresses up to case" do
		upcase_email = @attr[:email].upcase
		User.create!(@attr.merge(:email => upcase_email))
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.should_not be_valid
	end

end
