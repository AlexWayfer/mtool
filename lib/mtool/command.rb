# frozen_string_literal: true

require 'clamp'
require 'gorilla_patch/inflections'

module Mtool
	## Base class with helpers for commands
	class Command < Clamp::Command
		class << self
			using GorillaPatch::Inflections

			def inherited(command)
				caller_dir = File.dirname caller_locations(1..1).first.path
				command_name = command.underscore.split('/')[-2]

				command_name.clear if command_name == 'mtool'
				Dir[
					File.join caller_dir, command_name, '*.rb'
				].each { |sub_file| require sub_file }
			end
		end
	end
end
