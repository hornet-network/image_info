require 'stringio'

module ImageInfo
  class RequestHandler
    attr_reader :image, :buffer, :options

    def initialize(image, options: {})
      @image = image
      @buffer = StringIO.new
      @options = options
    end

    def build
      ::Typhoeus::Request.new(image.uri.to_s, followlocation: true, accept_encoding: :gzip, timeout: options[:http_read_timeout], connecttimeout: options[:http_open_timeout]).tap do |request|
        request.on_body do |chunk|
          buffer.write(chunk)
          buffer.rewind
          :abort if max_image_size_reached? || found_image_info?
        end
      end
    end

    private

    def found_image_info?
      ::ImageInfo::Parser.new(image, buffer).call
    end

    def max_image_size_reached?
      return false if max_image_size <= 0

      buffer.size > max_image_size
    end

    def max_image_size
      ::ImageInfo.config.max_image_size
    end
  end
end
