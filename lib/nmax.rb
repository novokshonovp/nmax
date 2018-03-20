require_relative './nmax/version'
require 'ruby-progressbar'

module Nmax
  class Stack < Array
    def add(number)
      return if number <= min
      sort!.shift
      push(number)
    end
  end
  class BigsParser
    DIGIT_PATTERN = /\d/
    attr_reader :greatest

    def initialize(stream, num_of_greatest, block_size = 2048)\
      raise 'Wrong block size!' if block_size <1
      raise 'Wrong number of greatest!' if num_of_greatest < 1
      @greatest = Stack.new(num_of_greatest, 0)
      @stream = stream
      @block_size = block_size
    end

    def parse
      progressbar = ProgressBar.create(title: 'Parse sample data...',
                                       starting_at: 0,
                                       total: File.size(@stream) / @block_size)
      loop do
        num_from_stream.each { |number| @greatest.add(number) }
        progressbar.increment if progressbar.progress < progressbar.total
        break if @stream.eof?
      end
      progressbar.finish
      self
    end

    private

    def num_from_stream
      read_next_block.scan(/\d+/).map(&:to_i)
    end

    def read_next_block
      block_size = @block_size
      block = ''
      loop do
        block << @stream.gets(block_size)
        block_size = Integer(Math.sqrt(block_size))
        break if DIGIT_PATTERN.match(block[-1]).nil? || @stream.eof?
      end
      block
    end
  end
end
