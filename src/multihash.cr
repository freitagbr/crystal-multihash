# require "uvarint"
require "./hashes"

module Multihash
  class Multihash
    @function_code : Int32

    def initialize(hash_function : String, len : Int32, digest : String)
      table : Hash(String, Int32) = HashFunctions::NAMES
      @function_code = table[hash_function]
      @len = len
      @digest = digest
    end

    def initialize(full : String)
      @function_code = full[0..1].to_i(16)
      @len = full[2, 3].to_i(16)
      @digest = full[4..-1]
    end

    def encode()
      encoded_len = @len.to_s(16)
      "#{@function_code.to_s(16)}#{encoded_len}#{@digest}"
    end

    def decode()
      @digest
    end
  end
end
