# frozen_string_literal: true

require 'pty'

RSpec.describe 'mt_init' do
	let(:file) { 'mt' }
	let(:command) { "#{__dir__}/../exe/mt_init" }

	subject(:run) { `#{command}` }

	let(:success_text) do
		<<~TEXT
			'mt' has been copied to '#{Dir.pwd}/'
		TEXT
	end

	around do |example|
		Dir.chdir __dir__ do
			example.run
		end
	end

	after do
		FileUtils.rm file if File.exist? file
	end

	it { is_expected.to eq success_text }

	describe 'file' do
		subject { file }

		before do
			run
		end

		describe 'exists' do
			subject { File.exist? super() }

			it { is_expected.to be true }
		end

		describe 'executable' do
			subject { File.executable? super() }

			it { is_expected.to be true }
		end
	end

	describe 'file aready exists' do
		let(:prompt_text) do
			<<~TEXT
				'mt' file already exists.

				Diff:

				 #!/bin/sh
				 \

				\e[31m-bundle exec foo\e[0m
				\e[32m+CURRENT_DIR=`dirname "$0"`\e[0m
				\e[32m+\e[0m
				\e[32m+bundle exec $CURRENT_DIR/mtool/root \"$@\"\e[0m

				Do you want to overwrite it?
			TEXT
		end

		let(:prompt_lines) { [] }
		let(:action_lines) { [] }

		before do
			File.write file, <<~TEXT
				#!/bin/sh

				bundle exec foo
			TEXT

			output, input = PTY.spawn command
			prompt_gone = false

			begin
				output.each_line($INPUT_RECORD_SEPARATOR, chomp: true) do |line|
					(prompt_gone ? action_lines : prompt_lines) << line

					next unless line.end_with?('?')

					input.puts answer
					output.gets ## for answer
					prompt_lines << ''
					prompt_gone = true
				end
			rescue Errno::EIO
				nil
			end

			action_lines << ''
		end

		describe 'question' do
			let(:answer) { 'no' }

			subject { prompt_lines.join("\n") }

			it { is_expected.to eq prompt_text }
		end

		describe 'answer' do
			subject { action_lines.join("\n") }

			context 'yes' do
				let(:answer) { 'yes' }

				it { is_expected.to eq success_text }
			end

			context 'no' do
				let(:answer) { 'no' }

				it { is_expected.to be_empty }
			end
		end
	end
end
