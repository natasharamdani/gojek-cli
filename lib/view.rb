module GoCLI
  # View is a class that show menus and forms to the screen
  class View
    # This is a class method called ".registration"
    # It receives one argument, opts with default value of empty hash
    # TODO: prompt user to input name and email -> DONE!
    def self.registration(opts = {})
      form = opts

      puts 'Registration'
      puts

      print 'Your name     : '
      form[:name] = gets.chomp

      print 'Your email    : '
      form[:email] = gets.chomp

      print 'Your phone    : '
      form[:phone] = gets.chomp

      print 'Your password : '
      form[:password] = gets.chomp

      form[:steps] << { id: __method__ }

      form
    end

    def self.login(opts = {})
      form = opts

      puts 'Login'
      puts

      print 'Enter your login    : '
      form[:login] = gets.chomp

      print 'Enter your password : '
      form[:password] = gets.chomp

      form[:steps] << { id: __method__ }

      form
    end

    def self.main_menu(opts = {})
      form = opts

      puts 'Welcome to Go-CLI!'
      puts

      puts 'Main Menu'
      puts '1. View Profile'
      puts '2. Order Go-Ride'
      puts '3. View Order History'
      puts '4. Go-Pay'
      puts '5. Exit'
      puts

      print 'Enter your option : '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    # TODO: Complete view_profile method -> DONE!
    def self.view_profile(opts = {})
      form = opts

      puts 'View Profile'
      puts

      # Show user data here
      puts "Name     : #{form[:user].name}"
      puts "Email    : #{form[:user].email}"
      puts "Phone    : #{form[:user].phone}"
      puts "Password : #{form[:user].password}"
      puts
      puts '1. Edit Profile'
      puts '2. Back'
      puts

      print 'Enter your option : '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    # TODO: Complete edit_profile method -> DONE!
    # This is invoked if user chooses Edit Profile menu when viewing profile
    def self.edit_profile(opts = {})
      form = opts

      puts 'Edit Profile'
      puts

      print 'Your new name     : '
      form[:name] = gets.chomp

      print 'Your new email    : '
      form[:email] = gets.chomp

      print 'Your new phone    : '
      form[:phone] = gets.chomp

      print 'Your new password : '
      form[:password] = gets.chomp

      puts
      puts '1. Save Profile'
      puts '2. Discard Changes'
      puts

      print 'Enter your option : '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    # TODO: Complete order_goride method -> DONE!
    def self.order_goride(opts = {})
      form = opts

      puts 'Order Go-Ride'
      puts

      print 'Origin      : '
      form[:origin] = gets.chomp

      print 'Destination : '
      form[:destination] = gets.chomp

      puts
      puts '1. GoJek'
      puts '2. GoCar'
      puts '3. Cancel'
      puts

      print 'Enter your option : '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    # TODO: Complete order_goride_confirm method -> DONE!
    # This is invoked after user finishes inputting data in order_goride method
    def self.order_goride_confirm(opts = {})
      form = opts

      puts 'Order Confirmation'
      puts

      puts "Origin       : #{form[:order].origin}"
      puts "Destination  : #{form[:order].destination}"
      puts "Type         : #{form[:order].type}"
      puts "Est Price    : #{form[:order].est_price}"
      puts

      print 'Voucher Code : '
      form[:code] = gets.chomp

      puts
      puts '1. Order'
      puts '2. Cancel'
      puts '3. Main Menu'
      puts

      print 'Enter your option : '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    def self.payment(opts = {})
      form = opts

      puts 'Payment'
      puts

      puts '1. Cash'
      puts '2. Go-Pay'
      puts

      print 'Enter your option : '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    def self.order_goride_nodriver(opts = {})
      form = opts

      puts "Sorry we can't find you a driver"
      puts

      puts '1. Try Again'
      puts '2. Main Menu'
      puts

      print 'Enter your option : '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    def self.order_goride_done(opts = {})
      form = opts

      puts 'Order Success'
      puts

      puts "Origin      : #{form[:order].origin}"
      puts "Destination : #{form[:order].destination}"
      puts "Type        : #{form[:order].type}"
      puts "Price       : #{form[:order].est_price}"
      puts "Driver      : #{form[:order].driver}"
      puts
      puts "Balance     : #{form[:user].gopay}"
      puts
      puts '1. Back'
      puts

      print 'Enter your option : '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    # TODO: Complete view_order_history method -> DONE!
    def self.view_order_history(opts = {})
      form = opts

      puts 'View Order History'
      puts

      form[:order].each do |history|
        puts "Origin      : #{history['origin']}"
        puts "Destination : #{history['destination']}"
        puts "Type        : #{history['type']}"
        puts "Price       : #{history['est_price']}"
        puts "Driver      : #{history['driver']}"
        puts
      end

      puts '1. Back'
      puts

      print 'Enter your option : '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    def self.gopay(opts = {})
      form = opts

      puts 'Go-Pay'
      puts

      puts "Name     : #{form[:user].name}"
      puts "Balance  : #{form[:user].gopay}"
      puts
      puts '1. Top Up'
      puts '2. Back'
      puts

      print 'Enter your option : '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    def self.topup(opts = {})
      form = opts

      puts 'Top Up'
      puts

      print 'Amount : '
      form[:topup] = gets.chomp.to_i

      puts
      puts '1. Proceed'
      puts '2. Cancel'
      puts

      print 'Enter your option : '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end
  end
end
