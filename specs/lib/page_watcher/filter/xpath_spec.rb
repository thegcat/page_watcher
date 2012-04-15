# encoding: utf-8
require 'spec_helper'

require 'page_watcher/filter/xpath'

describe PageWatcher::Filter::XPath do
  def example_html
    <<-HTML.gsub(/^ {6}/, '')
      <html>
        <ul>
          <li id="no">#{example_content_1}</li>
          <li id="yes">#{example_content_2}</li>
        </ul>
      </html>
    HTML
  end

  def example_xpath
    "//ul/li[@id='yes']/text()"
  end

  def example_content_1
    "You shouldn't find me all the time…"
  end

  def example_content_2
    "Find me if you can!"
  end

  it "should work when passed many strings in the input array" do
    PageWatcher::Filter::XPath.new(example_xpath).call([example_html, example_html]).must_equal [example_content_2, example_content_2]
  end

  describe "when the xpath returns one string" do
    it "should return the content we're looking for" do
      PageWatcher::Filter::XPath.new(example_xpath).call([example_html]).must_equal [example_content_2]
    end
  end

  describe "when the xpath returns multiple string" do
    def example_xpath
      "//ul/li/text()"
    end

    it "should return the content we're looking for" do
      PageWatcher::Filter::XPath.new(example_xpath).call([example_html]).must_equal [example_content_1, example_content_2]
    end
  end
end
