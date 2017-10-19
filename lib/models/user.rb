require 'json'

module GoCLI
  class User
    attr_accessor :name, :email, :phone, :password

    # TODO:
    # 1. Add two instance variables: name and email -> DONE!
    # 2. Write all necessary changes, including in other files -> DONE!
    def initialize(opts = {})
      @name     = opts[:name]     || ''
      @email    = opts[:email]    || ''
      @phone    = opts[:phone]    || ''
      @password = opts[:password] || ''
    end

    def self.load
      filename = "#{File.expand_path(File.dirname(__FILE__))}/../../data/user.json"

      return nil unless File.file?(filename)
      data = JSON.parse(File.read(filename))

      self.new(
        name:     data['name'],
        email:    data['email'],
        phone:    data['phone'],
        password: data['password']
      )
    end

    # TODO: Add your validation method here -> DONE!
    def validate
      !@name.empty? && !@email.empty? && !@phone.empty? && !@password.empty?
    end

    def save!
      # TODO: Add validation before writing user data to file -> DONE!
      user = {name: @name, email: @email, phone: @phone, password: @password}
      File.open("#{File.expand_path(File.dirname(__FILE__))}/../../data/user.json", "w") do |f|
        f.write JSON.generate(user)
      end
    end
  end
end
