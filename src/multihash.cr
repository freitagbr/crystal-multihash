# require "uvarint"
require "./hashes"

module Multihash
  HEX_SIZE_IN_BYTES = 2
  struct Multihash
    @hash_code : Int32
    @len : Int32

    def initialize(hash_name : String, digest : String)
      table : Hash(String, Int32) = HashFunctions::NAMES
      @hash_code = table[hash_name]
      @len = digest.size * HEX_SIZE_IN_BYTES
      @digest = digest
    end

    def initialize(full : String)
      # TODO(nate): replace this with real Varint parsing
      @hash_code = full[0..1].to_i(16)
      @len = full[2..3].to_i(16)
      @digest = full[4..-1]
    end

    # Accessors
    def hash_code
      @hash_code
    end

    def len
      @len
    end

    def digest
      @digest
    end

    # Serializing/encoding
    def to_s
      # TODO(nate): replace this with real Varint serializing
      serialized_hash_code = @hash_code.to_s(16)
      serialized_len = @len.to_s(16)
      "#{serialized_hash_code}#{serialized_len}#{@digest}"
    end

    # Comparison
    def ==(other : Multihash)
      (@hash_code == other.hash_code &&
       @len == other.len &&
       @digest == other.digest)
    end

    def !=(other : Multihash)
      !(self.==(other))
    end
  end


  # TODO(nate): remove this and use it as the basis for tests
  m = Multihash.new "0011deadbeef"
  # puts "deadbeef"
  puts "m.code:    0x" + m.hash_code.to_s 16 # => 0x00
  puts "m.len:     0x" + m.len.to_s 16 # => 0x11
  puts "m.digest:  " + m.digest # => "deadbeef"
  puts "m:         " + m.to_s
  m2 = Multihash.new("sha1", "cafebabe")
  puts "m2.code:   0x" + m2.hash_code.to_s 16
  puts "m2.len:    0x" + m2.len.to_s 16
  puts "m2.digest: " + m2.digest
  puts "m2:        " + m2.to_s
  # etc.

  # Comparison
  puts (m == m2) # => false
  puts (m != m2) # => true
end

