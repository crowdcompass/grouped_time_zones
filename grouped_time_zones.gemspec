# -*- encoding: utf-8 -*-
require File.expand_path('../lib/grouped_time_zones/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sean McCleary", "William Clifford"]
  gem.email         = ["seanmcc@gmail.com"]
  gem.description   = %q{Simple gem to take a grouped time zone selector for Rails}
  gem.summary       = %q{This has only been tested with Rails 3}
  gem.homepage      = "https://github.com/mrinterweb/grouped_time_zones"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "grouped_time_zones"
  gem.require_paths = ["lib"]
  gem.version       = GroupedTimeZones::VERSION

  gem.add_dependency "rails", "~>4.0"
  gem.add_development_dependency "rspec", "~>3.0"
  gem.add_development_dependency "rspec-collection_matchers"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "pry-nav"
  gem.add_development_dependency "nokogiri"
end
