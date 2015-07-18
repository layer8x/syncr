# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'syncr/version'

Gem::Specification.new do |spec|
  spec.name          = "syncr"
  spec.version       = Syncr::VERSION
  spec.authors       = ["sapslaj"]
  spec.email         = ["saps.laj@gmail.com"]

  spec.summary       = %q{a sort-of front end for Rsync}
  spec.homepage      = "sapslaj.github.io"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'listen'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"
end
