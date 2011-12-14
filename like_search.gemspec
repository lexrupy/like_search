# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "like_search/version"

Gem::Specification.new do |s|
  s.name        = "like_search"
  s.version     = LikeSearch::VERSION
  s.authors     = ["Alexandre da Silva"]
  s.email       = ["lexrupy@gmail.com"]
  s.homepage    = "https://github.com/lexrupy/like_search"
  s.summary     = %q{Search ActiveRecord models with Like}
  s.description = %q{Search ActiveRecord models with like}

  s.rubyforge_project = "like_search"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
