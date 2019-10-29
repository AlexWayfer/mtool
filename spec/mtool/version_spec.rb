# frozen_string_literal: true

RSpec.describe(constant = Mtool::VERSION) do
	subject { constant }

	it { is_expected.not_to be nil }
end
