# frozen_string_literal: true

require_relative 'lib/mtool/version'

Gem::Specification.new do |spec|
	spec.name          = 'mtool'
	spec.version       = Mtool::VERSION
	spec.authors       = ['Alexander Popov']
	spec.email         = ['alex.wayfer@gmail.com']

	spec.summary       = 'CLI multi-tool for application, replace of `rake`.'
	spec.description   = <<~DESC
		CLI multi-tool with custom sub-commands for any application, more comfortable replace of `rake`.
	DESC
	spec.homepage      = 'https://github.com/AlexWayfer/mtool'
	spec.license       = 'MIT'

	spec.metadata = {
		'homepage_uri' => spec.homepage,
		'source_code_uri' => 'https://github.com/AlexWayfer/mtool',
		'bug_tracker_uri' => 'https://github.com/AlexWayfer/mtool/issues',
		'changelog_uri' => 'https://github.com/AlexWayfer/mtool/blob/master/CHANGELOG.md'
	}

	## Specify which files should be added to the gem when it is released.
	## The `git ls-files -z` loads the files in the RubyGem
	## that have been added into git.
	spec.files = Dir.chdir(__dir__) do
		`git ls-files -z`.split("\x0").reject do |file|
			file.match(%r{^(test|spec|features)/})
		end
	end
	spec.bindir        = 'exe'
	spec.executables   = spec.files.grep(%r{^exe/}) { |file| File.basename(file) }
	spec.require_paths = ['lib']

	spec.required_ruby_version = '>= 2.5'

	spec.add_runtime_dependency 'clamp', '~> 1.3'
	spec.add_runtime_dependency 'diffy', '~> 3.3'
	spec.add_runtime_dependency 'gorilla_patch', '~> 3.0'
	spec.add_runtime_dependency 'highline', '~> 2.0'

	spec.add_development_dependency 'bundler', '~> 2.0'
	spec.add_development_dependency 'rake', '~> 10.0'
	spec.add_development_dependency 'rspec', '~> 3.0'
	spec.add_development_dependency 'rubocop', '~> 0.76.0'
	spec.add_development_dependency 'simplecov', '~> 0.17.1'
end
