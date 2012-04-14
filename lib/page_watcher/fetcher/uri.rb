require 'open-uri'

module PageWatcher
  module Fetcher
    class URI
      def initialize(config)
        @uri = config[:uri]
      end

      def call
        open(@uri).read
      end
    end
  end
end
