# TODO: Complete Location class
require 'json'

module GoCLI
  class Location
    attr_accessor :name, :coord

    def initialize(opts = {})
      @name       = opts[:name]  || ''
      @coord      = opts[:coord] || ''
    end

    def self.load
      data = JSON.parse(File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/locations.json"))
    end

    def self.find(position)
      data = JSON.parse(File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/locations.json"))
      coordinate = []
      data.each do |loc|
        if loc.value?(position)
          coordinate = loc['coord']
        end
      end
      coordinate
    end

    def self.calc_price(start, finish)
      1500*(Math.sqrt((finish[0] - start[0])**2 + (finish[1] - start[1])**2)).to_f
    end

    def self.find_driver(cust)
      data = JSON.parse(File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/fleet_location.json"))
      fleet = []
      driver = ''
      data.each do |loc|
        fleet = loc['location']
        if Math.sqrt((fleet[0] - cust[0])**2 + (fleet[1] - cust[1])**2).to_f <= 1.0
          driver = loc['driver']
          break
        end
      end
      driver
    end
  end
end
