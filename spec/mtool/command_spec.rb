# frozen_string_literal: true

RSpec.describe Mtool::Command do
	subject { `./mt --help` }

	around do |example|
		Dir.chdir "#{__dir__}/foo" do
			example.run
		end
	end

	it { is_expected.to eq 'help' }
end
