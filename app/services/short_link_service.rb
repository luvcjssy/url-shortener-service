class ShortLinkService
  class << self
    ALPHABET = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.split(//)

    def generator(from = Time.now, to = 1.day.from_now)
      short_links = []
      (from.to_i..to.to_i).each { |unix_time| short_links << { code: base64_encode(unix_time) } }
      AvailableCode.insert_all(short_links) unless short_links.empty?
    end

    private

    def base64_encode(unix_time)
      return ALPHABET[0] if unix_time == 0

      short_link = ''
      base = ALPHABET.length
      while unix_time > 0
        short_link << ALPHABET[unix_time % base]
        unix_time /= base
      end
      short_link.reverse
    end
  end
end
