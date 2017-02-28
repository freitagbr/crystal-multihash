module VarInt
    MSB = 0x80_u8
    REST = 0x7F_u8
    MSBALL = -128_i8
    INT = 0x80000000_u32

    def encode(n)
        encoded = [] of UInt8
        offset = 0
        while n >= INT
            encoded << UInt8.new((n & 0xFF) | MSB)
            offset += 1
            n = n / 128
        end
        while (n & MSBALL) != 0
            encoded << UInt8.new((n & 0xFF) | MSB)
            offset += 1
            n = UInt8.new(n >> 7)
        end
        encoded << UInt8.new(n | 0)
        return encoded
    end

    def decode(buf : Array(UInt8))
        res = 0_u64
        counter = 0
        shift = 0
        while true
            b = UInt64.new(buf[counter])
            counter += 1
            res += if shift < 28
                       (b & REST) << shift
                   else
                       (b & REST) * (2 ** shift)
                   end
            shift += 7
            break if b < MSB
        end
        return res
    end
end
