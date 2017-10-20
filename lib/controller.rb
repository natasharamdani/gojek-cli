require_relative './models/user'
require_relative './models/order'
require_relative './models/location'
require_relative './models/fleet'
require_relative './models/promo'
require_relative './view'

module GoCLI
  # Controller is a class that call corresponding models and methods for every action
  class Controller
    # This is an example how to create a registration method for your controller
    def registration(opts = {})
      # First, we clear everything from the screen
      clear_screen(opts)

      # Second, we call our View and its class method called "registration"
      # Take a look at View class to see what this actually does
      form = View.registration(opts)

      # This is the main logic of this method:
      # - passing input form to an instance of User class (named "user")
      # - invoke ".save!" method to user object
      # TODO: enable saving name and email -> DONE!
      user = User.new(
        name:     form[:name],
        email:    form[:email],
        phone:    form[:phone],
        password: form[:password],
        gopay:    0
      )
      if user.validate
        user.save!

        # Assigning form[:user] with user object
        form[:user] = user

        # Returning the form
        form

      else
        form[:flash_msg] = 'Please fill out all fields'
        registration(opts)
      end
    end

    def login(opts = {})
      halt = false
      while !halt
        clear_screen(opts)
        form = View.login(opts)

        # Check if user inputs the correct credentials in the login form
        if credential_match?(form[:user], form[:login], form[:password])
          halt = true
        else
          form[:flash_msg] = 'Wrong login or password combination'
        end
      end

      form
    end

    def main_menu(opts = {})
      clear_screen(opts)
      form = View.main_menu(opts)

      case form[:steps].last[:option].to_i
      when 1
        # Step 4.1
        view_profile(form)
      when 2
        # Step 4.2
        order_goride(form)
      when 3
        # Step 4.3
        view_order_history(form)
      when 4
        gopay(form)
      when 5
        exit(true)
      else
        form[:flash_msg] = 'Wrong option entered, please retry'
        main_menu(form)
      end
    end

    def view_profile(opts = {})
      clear_screen(opts)
      form = View.view_profile(opts)

      case form[:steps].last[:option].to_i
      when 1
        # Step 4.1.1
        edit_profile(form)
      when 2
        main_menu(form)
      else
        form[:flash_msg] = 'Wrong option entered, please retry'
        view_profile(form)
      end
    end

    # TODO: Complete edit_profile method -> DONE!
    # This will be invoked when user choose Edit Profile menu in view_profile screen
    def edit_profile(opts = {})
      clear_screen(opts)
      form = View.edit_profile(opts)

      case form[:steps].last[:option].to_i
      when 1
        user = User.load
        user = User.new(
          name:     form[:name],
          email:    form[:email],
          phone:    form[:phone],
          password: form[:password],
          gopay:    user.gopay
        )
        user.save!
        form[:user] = user
        view_profile(form)
      when 2
        view_profile(form)
      else
        form[:flash_msg] = 'Wrong option entered, please retry'
        edit_profile(form)
      end
    end

    # TODO: Complete order_goride method -> DONE!
    def order_goride(opts = {})
      clear_screen(opts)
      form = View.order_goride(opts)

      type = ''
      price = 0
      case form[:steps].last[:option].to_i
      when 1
        type = 'GoJek'
        price = 1500
      when 2
        type = 'GoCar'
        price = 2500
      when 3
        main_menu(form)
      else
        form[:flash_msg] = 'Wrong option entered, please retry'
        order_goride(form)
      end

      start = Location.find(form[:origin])
      finish = Location.find(form[:destination])

      if !start.empty? && !finish.empty?
        est_price = Order.calc_price(start, finish, price)

        order = Order.new(
          origin:      form[:origin],
          destination: form[:destination],
          est_price:   est_price.round,
          type:        type
        )
        form[:order] = order

        order_goride_confirm(form)

      else
        form[:flash_msg] = "We're not serving that route yet"
        order_goride(form)
      end
    end

    # TODO: Complete order_goride_confirm method -> DONE!
    # This will be invoked after user finishes inputting data in order_goride method
    def order_goride_confirm(opts = {})
      clear_screen(opts)
      form = View.order_goride_confirm(opts)

      case form[:steps].last[:option].to_i
      when 1
        form = opts

        cust = Location.find(form[:origin])
        driver = Fleet.find_driver(cust)
        dest = Location.find(form[:destination])

        if !driver.empty?
          order = Order.new(
            timestamp:   '',
            origin:      form[:order].origin,
            destination: form[:order].destination,
            est_price:   form[:order].est_price,
            type:        form[:order].type,
            driver:      driver
          )
          order.save!

          fleet = Fleet.new(
            type:     form[:order].type,
            driver:   driver,
            location: dest
          )
          fleet.move_driver!

          form[:order] = order

          payment(form)

        else
          order_goride_nodriver(form)
        end

      when 2
        order_goride(form)

      when 3
        main_menu(form)

      else
        form[:flash_msg] = 'Wrong option entered, please retry'
        order_goride_confirm(form)
      end
    end

    def payment(opts = {})
      clear_screen(opts)
      form = View.payment(opts)

      case form[:steps].last[:option].to_i
      when 1
        order_goride_done(form)
      when 2
        user = User.load
        user = User.new(
          name:     user.name,
          email:    user.email,
          phone:    user.phone,
          password: user.password,
          gopay:    user.gopay - form[:order].est_price
        )
        user.save!
        form[:user] = user
        order_goride_done(form)
      else
        form[:flash_msg] = 'Wrong option entered, please retry'
        payment(form)
      end
    end

    def order_goride_nodriver(opts = {})
      clear_screen(opts)
      form = View.order_goride_nodriver(opts)

      case form[:steps].last[:option].to_i
      when 1
        order_goride(form)
      when 2
        main_menu(form)
      else
        form[:flash_msg] = 'Wrong option entered, please retry'
        order_goride_nodriver(form)
      end
    end

    def order_goride_done(opts = {})
      clear_screen(opts)
      form = View.order_goride_done(opts)

      case form[:steps].last[:option].to_i
      when 1
        main_menu(form)
      else
        form[:flash_msg] = 'Wrong option entered, please retry'
        order_goride_done(form)
      end
    end

    def view_order_history(opts = {})
      clear_screen(opts)

      form = opts

      form[:order] = Order.load

      form = View.view_order_history(opts)

      case form[:steps].last[:option].to_i
      when 1
        main_menu(form)
      else
        form[:flash_msg] = 'Wrong option entered, please retry'
        view_order_history(form)
      end
    end

    def gopay(opts = {})
      clear_screen(opts)
      form = View.gopay(opts)

      case form[:steps].last[:option].to_i
      when 1
        topup(form)
      when 2
        main_menu(form)
      else
        form[:flash_msg] = 'Wrong option entered, please retry'
        gopay(form)
      end
    end

    def topup(opts = {})
      clear_screen(opts)
      form = View.topup(opts)

      case form[:steps].last[:option].to_i
      when 1
        user = User.load
        user = User.new(
          name:     user.name,
          email:    user.email,
          phone:    user.phone,
          password: user.password,
          gopay:    user.gopay + form[:topup]
        )
        user.save!
        form[:user] = user
      when 2
      else
        form[:flash_msg] = 'Wrong option entered, please retry'
      end
      gopay(form)
    end

    protected

    # You don't need to modify this
    def clear_screen(opts = {})
      Gem.win_platform? ? (system 'cls') : (system 'clear')
      if opts[:flash_msg]
        puts opts[:flash_msg]
        puts ''
        opts[:flash_msg] = nil
      end
    end

    # TODO: credential matching with email or phone -> DONE!
    def credential_match?(user, login, password)
      false unless user.email == login || user.phone == login
      false unless user.password == password
      true
    end
  end
end
