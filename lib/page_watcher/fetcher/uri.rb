require 'open-uri'

module PageWatcher
  module Fetcher
    class URI
      def initialize(uri)
        @uri = uri
      end

      def call
        [open(@uri).read]
      end
    end
  end
end
