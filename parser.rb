# frozen_string_literal: true

require_relative 'structure'

class Parser
  KEY_VALUES_PAIR_REGEX = /([a-z0-9_]+)=(.*)/.freeze
  INTEGER_REGEX = /^[0-9]+$/.freeze
  STRING_REGEX = /"(.*?)"/.freeze

  attr_reader :stream

  def initialize(stream)
    @stream = stream
    @read_lines = 0
  end

  def parse
    read_struct(Structure.new)
  end

  private

  def read_struct(struct)
    until stream.eof?
      line = read_line

      next if line.empty?
      break if line == '}'

      struct << parse_line(line)
    end

    struct.serialize
  end

  def parse_line(line)
    match_data = line.match(KEY_VALUES_PAIR_REGEX)

    if match_data
      parse_key_value_pair(match_data[1], match_data[2])
    else
      parse_value(line)
    end
  end

  def parse_key_value_pair(key, value)
    [key, parse_value(value)]
  end

  # :reek:FeatureEnvy
  def parse_value(value)
    return read_struct(Structure.new) if value == '{'

    match_data = value.match(STRING_REGEX)

    return match_data[1] if match_data
    return value.to_i if value =~ INTEGER_REGEX

    value.to_f
  end

  def read_line
    line = stream.readline.strip
    @read_lines += 1
    line
  end
end
