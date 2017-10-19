# TODO: Complete Order class
require 'json'

module GoCLI
  class Order
    attr_accessor :origin, :destination, :est_price, :driver

    def initialize(opts = {})
      @origin      = opts[:origin]      || ''
      @destination = opts[:destination] || ''
      @est_price   = opts[:est_price]   || ''
      @driver      = opts[:driver]      || ''
    end

    def self.load
      data = JSON.parse(File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/orders.json"))
    end

    def save! # push to array
      data = JSON.parse(File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/orders.json"))
      order = {timestamp: Time.now, origin: @origin, destination: @destination, est_price: @est_price,  driver: @driver}
      data << order
      File.open("#{File.expand_path(File.dirname(__FILE__))}/../../data/orders.json", "w") do |f|
        f.write JSON.generate(data)
      end
    end
  end
end
