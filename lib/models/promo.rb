require 'json'

module GoCLI
  # class promo
  class Promo
    attr_accessor :code, :type, :disc

    def initialize(opts = {})
      @code = opts[:code] || ''
      @type = opts[:type] || ''
      @disc = opts[:disc] || ''
    end

    def self.load
      JSON.parse(File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/promo.json"))
    end

    def self.discount(code, price)
      data = JSON.parse(File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/fleets.json"))
      data.each do |hsh|
        if hsh['code'] == code
          price = price - hsh['disc']           if hsh['type'] == '$'
          price = price - (price * hsh['disc']) if hsh['type'] == '%'
        end
      end
      price
    end
  end
end
