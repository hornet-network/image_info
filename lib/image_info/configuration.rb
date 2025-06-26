module ImageInfo
  class Configuration
    attr_accessor :max_concurrency, :max_image_size, :http_open_timeout, :http_read_timeout

    def initialize
      @max_concurrency = 20
      @max_image_size = -1
      @http_open_timeout = nil
      @http_read_timeout = nil
    end
  end
end
