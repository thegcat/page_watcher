# encoding: utf-8
require 'spec_helper'

require 'page_watcher/filter/xpath'

describe PageWatcher::Filter::XPath do
  def example_html
    <<-HTML.gsub(/^ {6}/, '')
      <html>
        <ul>
          <li id="no">Not the content we want…</li>
          <li id="yes">#{example_content}</li>
        </ul>
      </html>
    HTML
  end

  def example_xpath
    "//ul/li[@id='yes']/text()"
  end

  def example_content
    "Find me if you can!"
  end

  it "should return the content we're looking for" do
    PageWatcher::Filter::XPath.new(:xpath => example_xpath).call(example_html).must_equal [example_content]
  end
end
