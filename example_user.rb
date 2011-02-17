class User
	attr_accessor :name, :email

	def initialize(attributes = {})
		@name = attributes[:name]
		@email = attributes[:email]
	end

	def formated_email
		"#{@name} <#{@email}>"
	end
end
