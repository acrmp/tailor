require 'erb'
require 'yaml'
require 'log_switch'
require 'term/ansicolor'
require 'fileutils'
require_relative 'tailor/runtime_error'
require_relative 'tailor/line_lexer'

class String
  include Term::ANSIColor
end

class Tailor
  extend LogSwitch

  #self.log = true

  class << self
    # Main entry-point method.
    #
    # @param [String] path File or directory to check files in.
    def check_style(path)
      file_list(path).each do |file|
        check_file(file)
      end
    end

    # The list of the files in the project to check.
    #
    # @param [String] path Path to the file or directory to check.
    # @return [Array] The list of files to check.
    def file_list(path=nil)
      return @file_list if @file_list

      if File.directory? path
        FileUtils.cd path
      else
        return [path]
      end

      files_in_project = Dir.glob(File.join('*', '**', '*'))
      Dir.glob(File.join('*')).each { |file| files_in_project << file }

      list_with_absolute_paths = []

      files_in_project.each do |file|
        if File.file? file
          list_with_absolute_paths << File.expand_path(file)
        end
      end

      @file_list = list_with_absolute_paths.sort
    end

    # Adds problems found from Lexing to the {problems} list.
    #
    # @param [String] file The file to open, read, and check.
    def check_file file
      Tailor.log "<#{self.name}> Checking style of a single file: #{file}."
      lexer = Tailor::LineLexer.new(file)
      lexer.lex
      problems[file] = lexer.problems
    end

    # @todo This could delegate to Ruport (or something similar) for allowing
    #   output of different types.
    def print_report
      if problems.empty?
        puts "Your files are in style."
      else
        summary_table = Text::Table.new
        summary_table.head = [{ value: "Tailor Summary", colspan: 2 }]
        summary_table.rows << [{ value: "File", align: :center},
          { value: "Total Problems", align: :center }]
        summary_table.rows << :separator

        problems.each do |file, problem_list|
          unless problem_list.empty?
            print_file_problems(file, problem_list)

          end

          summary_table.rows << [file, problem_list.size]
        end

        puts summary_table
      end
    end

    def print_file_problems(file, problem_list)
      message = <<-MSG
#-------------------------------------------------------------------------------
# File:\t#{file}
#-------------------------------------------------------------------------------
# Problems:
      MSG
      problem_list.each_with_index do |problem, i|
        message << %Q{#  #{(i + 1).to_s.bold}.
#    * line:    #{problem[:line].to_s.red.bold}
#    * type:    #{problem[:type].to_s.red}
#    * message: #{problem[:message].red}
}
      end
      message << <<-MSG
#
#-------------------------------------------------------------------------------
      MSG

      puts message
    end

    # @return [Hash]
    def problems
      @problems ||= {}
    end

    # @return [Fixnum] The number of problems found so far.
    def problem_count
      problems.values.flatten.size
    end

    # Checks to see if +path_to_check+ is a real file or directory.
    #
    # @param [String] path_to_check
    # @return [Boolean]
    def checkable? path_to_check
      File.file?(path_to_check) || File.directory?(path_to_check)
    end

    # Tries to load a config file from ~/.tailor, then fails back on default
    # settings.
    #
    # @return [Hash] The configuration read from the config file or the default
    #   config.
    def config
      return @config if @config
      user_config_file = File.expand_path(Dir.home + '/.tailorrc')

      @config = if File.exists? user_config_file
        YAML.load_file user_config_file
      else
        erb_file = File.expand_path(File.dirname(__FILE__) + '/../tailor_config.yaml.erb')
        default_config_file = ERB.new(File.read(erb_file)).result(binding)
        YAML.load default_config_file
      end
    end

    # Use a different config file.
    #
    # @param [String] new_config_file Path to the new config file.
    def config=(new_config_file)
      @config = YAML.load_file(new_config_file)
    end
  end
end
