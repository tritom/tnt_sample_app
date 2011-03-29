require 'spec_helper'

describe User do

	before(:each) do
		@attr = { :name => "Example User", 
							:email => "user@example.com", 
							:password => "foobar",
							:password_confirmation => "foobar" }
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

	describe "password validations" do
		it "should require a password" do
			user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
			user.should_not be_valid
		end

		it "should require password and confirmation_password to be the same" do
			user = User.new(@attr.merge(:password_confirmation => "invalid"))
			user.should_not be_valid
		end

		it "should require password to be at least 6 characters" do
			short = 'a' * 5
			user = User.new(@attr.merge(:password => short, :password_confirmation => short))
			user.should_not be_valid
		end

		it "should require password to be less than 40 characters" do
			long = 'a' * 41
			user = User.new(@attr.merge(:password => long, :password_confirmation => long))
			user.should_not be_valid
		end
	end

	describe "password encryption" do
		before(:each) do
			@user = User.create!(@attr)
		end

		it "should have an encrypted password attribute" do
			@user.should respond_to(:encrypted_password)
		end

		it "should set the encrypted password" do
			@user.encrypted_password.should_not be_blank
		end
		
		describe "has_password? method" do
			it "should be true if the passwords match" do
				@user.has_password?(@attr[:password]).should be_true
			end

			it "should be false if the passwords do not match" do
				@user.has_password?("wrong").should be_false
			end
		end

		describe "authenticate method" do
			it "should return nil if email/password mismatch" do
				wrong_user_password = User.authenticate(@attr[:email], "mismatch")
				wrong_user_password.should be_nil
			end

			it "should return nil for an email address with no user" do
				nonexistent_user = User.authenticate("missing@email.com", @attr[:password])
				nonexistent_user.should be_nil
			end

			it "should return user if email/password match" do
				matching_user = User.authenticate(@attr[:email], @attr[:password])
				matching_user.should == @user
			end
		end
	end

end
