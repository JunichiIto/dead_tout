# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dead_tout/version'

Gem::Specification.new do |spec|
  spec.name          = "dead_tout"
  spec.version       = DeadTout::VERSION
  spec.authors       = ["Junichi Ito"]
  spec.email         = ["jit@sonicgarden.jp"]

  spec.summary       = %q{List outdated gems in Gemfile.}
  spec.description   = %q{List outdated gems in Gemfile.}
  spec.homepage      = "https://github.com/JunichiIto/dead_tout"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = %w(dead_tout)
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
