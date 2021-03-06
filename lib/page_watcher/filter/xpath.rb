require 'nokogiri'

module PageWatcher
  module Filter
    class XPath
      def initialize(xpath)
        @xpath = xpath
      end

      def call(strings = [])
        strings.map {|string| Nokogiri::HTML(string).xpath(@xpath)}.flatten.map(&:to_s)
      end
    end
  end
end
