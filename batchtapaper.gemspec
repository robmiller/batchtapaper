Gem::Specification.new do |s|
	s.name = "batchtapaper"
	s.version = "1.1.1"
	s.executables << 'batchtapaper'
	s.date = "2013-03-19"
	s.summary = "Bulk-add URLs to Instapaper"
	s.description = "Easily add multiple URLs to Instapaper, either from a file or from STDIN."
	s.authors = ["Rob Miller"]
	s.email = "rob@bigfish.co.uk"
	s.files = ["bin/batchtapaper"]
	s.homepage = "https://github.com/robmiller/batchtapaper"

  s.license = "MIT"

  s.add_runtime_dependency "faraday", "~> 0.8"

  s.add_development_dependency "pry", "~> 0.9"
end
