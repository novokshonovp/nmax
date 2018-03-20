require "nmax/version"

module Nmax
  
  class Stack < Array
    def add(number)
      return if number <= min
      sort!.shift
      push(number)
    end
  end
  class BigsParser
    attr_reader :greatest
    def initialize(sample_data, num_of_greatest)
      @greatest = Stack.new(num_of_greatest, 0)
      @std_in = sample_data
    end

    def parse
      @greatest.add(@std_in.gets(' ').to_i) until @std_in.eof?
      self
    end
  end

end
