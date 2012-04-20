require 'spec_helper'
require 'fakeweb'

require 'page_watcher/fetcher/uri'

describe PageWatcher::Fetcher::URI do
  def example_content
    "This is an example content!\n"
  end

  before do
    FakeWeb.register_uri(:any, "http://www.example.net/", :body => example_content)
  end

  it "should return the contents of the file at config[:uri]" do
    PageWatcher::Fetcher::URI.new("http://www.example.net").call.must_equal [example_content]
  end
end
