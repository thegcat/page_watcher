require 'spec_helper'
require 'fake_web'

require 'page_watcher/fetcher/uri'

describe PageWatcher::Fetcher::URI do
  def example_content
    "This is an example content!\n"
  end

  before do
    FakeWeb.register_uri("http://www.example.net/", :string => example_content)
  end

  it "should return the contents of the file at config[:uri]" do
    PageWatcher::Fetcher::URI.new({:uri => "http://www.example.net"}).call.must_equal example_content
  end
end
