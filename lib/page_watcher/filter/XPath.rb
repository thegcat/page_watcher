require 'nokogiri'

module PageWatcher
  module Filter
    class XPath
      def initialize(config)
        @xpath = config[:xpath]
      end

      def call(string)
        Nokogiri::HTML(string).xpath(@xpath).map(&:to_s)
      end
    end
  end
end
