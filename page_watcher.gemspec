# -*- encoding: utf-8 -*-
require File.expand_path('../lib/page_watcher/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Felix Sch\303\244fer"]
  gem.email         = ["felix@fachschaften.org"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "page_watcher"
  gem.require_paths = ["lib"]
  gem.version       = PageWatcher::VERSION

  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'FakeWeb'
end
