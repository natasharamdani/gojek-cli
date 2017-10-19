# TODO: Complete Location class
require 'json'

module GoCLI
  class Location
    attr_accessor :name, :coord

    def initialize(opts = {})
      @name  = opts[:name]  || ''
      @coord = opts[:coord] || ''
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
  end
end
