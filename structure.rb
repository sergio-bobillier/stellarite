# frozen_string_literal: true

class Structure
  def initialize
    @array = []
    @hash = {}
  end

  def <<(item)
    item.is_a?(Array) ? push_to_hash(item) : push_to_array(item)
  end

  def serialize
    @hash.empty? ? @array : @hash
  end

  private

  def push_to_hash(item)
    key = item[0]
    value = item[1]

    if @hash.key?(key)
      @hash[key] = [@hash[key]] unless @hash[key].is_a?(Array)
      @hash[key] << value
    else
      @hash[key] = value
    end
  end

  def push_to_array(item)
    @array << item
  end
end
