require 'json'

module GoCLI
  # class fleet
  class Fleet
    attr_accessor :type, :driver, :location

    def initialize(opts = {})
      @type     = opts[:type]     || ''
      @driver   = opts[:driver]   || ''
      @location = opts[:location] || ''
    end

    def self.load
      JSON.parse(File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/fleets.json"))
    end

    def self.find_driver(cust)
      data = JSON.parse(File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/fleets.json"))
      fleet = []
      driver = ''
      data.each do |hsh|
        fleet = hsh['location']
        if Math.sqrt((fleet[0] - cust[0])**2 + (fleet[1] - cust[1])**2).to_f <= 1.0
          driver = hsh['driver']
          break
        end
      end
      driver
    end

    def move_driver!
      data = JSON.parse(File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/fleets.json"))
      data.delete_if { |hsh| hsh['driver'] == @driver }
      new_loc = { type: @type, driver: @driver, location: @location }
      data << new_loc
      File.open("#{File.expand_path(File.dirname(__FILE__))}/../../data/fleets.json", 'w') do |f|
        f.write JSON.generate(data)
      end
    end
  end
end
