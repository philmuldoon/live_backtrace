require_relative 'lib/live_backtrace/version'

Gem::Specification.new do |spec|
  spec.name          = 'live_backtrace'
  spec.version       = LiveBacktrace::VERSION
  spec.authors       = 'Phil Muldoon'
  spec.email         = 'pkmuldoon@picobot.org'

  spec.summary       = 'A client-server architecture that propagates live traces.'
  spec.description   = <<-EOF
    Populates a live backtrace across a socket
  EOF
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')
  spec.homepage      = 'http://www.picobot.org'
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.

  #spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
  #  `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  #end
  spec.files = Dir['lib/**/*.rb']
  spec.files += Dir['bin/*']
  spec.files += Dir['[A-Z]*'] + Dir['spec/**/*']

  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rainbow', '~> 3.0'
  spec.add_runtime_dependency 'rouge', '~> 3.24'
  spec.add_development_dependency 'rainbow', '~> 3.0'
  spec.add_development_dependency 'rouge', '~> 3.24'
end
