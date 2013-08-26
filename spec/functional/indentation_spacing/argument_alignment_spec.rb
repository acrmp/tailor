require 'spec_helper'
require_relative '../../support/argument_alignment_cases'
require 'tailor/critic'
require 'tailor/configuration/style'

describe 'Argument alignment' do

  def file_name
    self.class.description
  end

  def contents
    ARG_INDENT[file_name] || begin
      raise "Example not found: #{file_name}"
    end
  end

  before do
    Tailor::Logger.stub(:log)
    FakeFS.activate!
    FileUtils.touch file_name
    File.open(file_name, 'w') { |f| f.write contents }
  end

  let(:critic) { Tailor::Critic.new }

  let(:style) do
    style = Tailor::Configuration::Style.new
    style.trailing_newlines 0, level: :off
    style.allow_invalid_ruby true, level: :off
    style
  end

  context :def_no_arguments do

    it 'does not warn when argument alignment is not specified' do
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

    it 'does not warn when argument alignment is disabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: :off
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

    it 'does not warn when argument alignment is enabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: true
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

  end

  context :def_arguments_fit_on_one_line do

    it 'does not warn when argument alignment is not specified' do
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

    it 'does not warn when argument alignment is disabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: :off
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

    it 'does not warn when argument alignment is enabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: true
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

  end

  context :def_arguments_aligned do

    it 'warns when argument alignment is not specified' do
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to eql [{
        :type => 'indentation_spaces',
        :line => 2,
        :column=> 14,
        :message=> "Line is indented to column 14, but should be at 2.",
        :level=> :error
      }]
    end

    it 'warns when argument alignment is disabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: :off
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to eql [{
        :type => 'indentation_spaces',
        :line => 2,
        :column=> 14,
        :message=> "Line is indented to column 14, but should be at 2.",
        :level=> :error
      }]
    end

    it 'does not warn when argument alignment is enabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: true
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

  end

  context :def_arguments_indented do

    it 'does not warn when argument alignment is not specified' do
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

    it 'does not warn when argument alignment is disabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: :off
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

    it 'warns when argument alignment is enabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: true
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to eql [{
        :type => 'indentation_spaces',
        :line => 2,
        :column=> 2,
        :message=> "Line is indented to column 2, but should be at 14.",
        :level=> :error
      }]
    end

  end

  context :call_arguments_fit_on_one_line do

    it 'does not warn when argument alignment is not specified' do
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

    it 'does not warn when argument alignment is disabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: :off
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

    it 'does not warn when argument alignment is enabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: true
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

  end

  context :call_no_arguments do

    it 'does not warn when argument alignment is not specified' do
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

    it 'does not warn when argument alignment is disabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: :off
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

    it 'does not warn when argument alignment is enabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: true
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

  end

  context :call_arguments_aligned do

    it 'warns when argument alignment is not specified' do
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to eql [{
        :type => 'indentation_spaces',
        :line => 2,
        :column=> 49,
        :message=> "Line is indented to column 49, but should be at 2.",
        :level=> :error
      }]
    end

    it 'warns when argument alignment is disabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: :off
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to eql [{
        :type => 'indentation_spaces',
        :line => 2,
        :column=> 49,
        :message=> "Line is indented to column 49, but should be at 2.",
        :level=> :error
      }]
    end

    it 'does not warn when argument alignment is enabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: true
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

  end

  context :call_arguments_aligned_multiple_lines do

    it 'warns when argument alignment is not specified' do
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to eql [
        {
          :type => 'indentation_spaces',
          :line => 2,
          :column=> 49,
          :message=> "Line is indented to column 49, but should be at 2.",
          :level=> :error
        },
        {
          :type => 'indentation_spaces',
          :line => 3,
          :column=> 49,
          :message=> "Line is indented to column 49, but should be at 2.",
          :level=> :error
        }
      ]
    end

    it 'warns when argument alignment is disabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: :off
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to eql [
        {
          :type => 'indentation_spaces',
          :line => 2,
          :column=> 49,
          :message=> "Line is indented to column 49, but should be at 2.",
          :level=> :error
        },
        {
          :type => 'indentation_spaces',
          :line => 3,
          :column=> 49,
          :message=> "Line is indented to column 49, but should be at 2.",
          :level=> :error
        }
      ]
    end

    it 'does not warn when argument alignment is enabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: true
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

  end

  context :call_arguments_aligned_no_parens do

    it 'warns when argument alignment is not specified' do
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to eql [{
        :type => 'indentation_spaces',
        :line => 2,
        :column=> 49,
        :message=> "Line is indented to column 49, but should be at 2.",
        :level=> :error
      }]
    end

    it 'warns when argument alignment is disabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: :off
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to eql [{
        :type => 'indentation_spaces',
        :line => 2,
        :column=> 49,
        :message=> "Line is indented to column 49, but should be at 2.",
        :level=> :error
      }]
    end

    it 'warns when argument alignment is enabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: true
      critic.check_file(file_name, style.to_hash)
      # This is not the desired behaviour. We actually want to not warn for
      # multi-line function calls without parentheses, but at present we only
      # handle calls that use parentheses.
      expect(critic.problems[file_name]).to eql [{
        :type => 'indentation_spaces',
        :line => 2,
        :column=> 49,
        :message=> "Line is indented to column 49, but should be at 2.",
        :level=> :error
      }]
    end

  end

  context :call_arguments_indented do

    it 'does not warn when argument alignment is not specified' do
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

    it 'does not warn when argument alignment is disabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: :off
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

    it 'warns when argument alignment is enabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: true
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to eql [{
        :type => 'indentation_spaces',
        :line => 2,
        :column=> 2,
        :message=> "Line is indented to column 2, but should be at 49.",
        :level=> :error
      }]
    end

  end

  context :call_arguments_indented_separate_line do

    it 'does not warn when argument alignment is not specified' do
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

    it 'does not warn when argument alignment is disabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: :off
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

    it 'does not warn when argument alignment is enabled' do
      style.indentation_spaces 2, level: :error, argument_alignment: true
      critic.check_file(file_name, style.to_hash)
      expect(critic.problems[file_name]).to be_empty
    end

  end

end
