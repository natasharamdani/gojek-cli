# TODO: Complete Location class
require 'json'

module GoCLI
  # class location
  class Location
    attr_accessor :name, :coord

    def initialize(opts = {})
      @name  = opts[:name]  || ''
      @coord = opts[:coord] || ''
    end

    def self.load
      JSON.parse(File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/locations.json"))
    end

    def self.find(position)
      data = JSON.parse(File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/locations.json"))
      coordinate = []
      data.each do |loc|
        coordinate = loc['coord'] if loc.value?(position)
      end
      coordinate
    end
  end
end
