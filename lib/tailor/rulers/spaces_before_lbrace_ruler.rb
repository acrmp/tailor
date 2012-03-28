require_relative '../ruler'

class Tailor
  module Rulers
    
    # Detects spaces before a '{' as given by +@config+.  It skips checking
    # when:
    # * it's the first char in the line.
    # * the char before it is a '#{'.
    # * the char before it is a '('.
    # * the char before it is a '['.
    # * it's only preceded by spaces.
    class SpacesBeforeLBraceRuler < Tailor::Ruler
      
      # @param [LexedLine] lexed_line
      # @param [Fixnum] column
      # @return [Fixnum] The number of spaces before the lbrace.
      def count_spaces(lexed_line, column)
        current_index = lexed_line.event_index(column)
        log "Current event index: #{current_index}"
        previous_event = lexed_line.at(current_index - 1)
        log "Previous event: #{previous_event}"

        if column.zero? || previous_event.nil? ||
          previous_event[1] == :on_embexpr_beg ||
          previous_event[1] == :on_lparen ||
          previous_event[1] == :on_lbracket
          return nil
        end
        
        return 0 if previous_event[1] != :on_sp
        return nil if current_index - 2 < 0
        
        previous_event.last.size
      end

      def lbrace_update(lexed_line, lineno, column)
        count = count_spaces(lexed_line, column)
        
        if count.nil?
          log "lbrace must be at the beginning of the line."
          return
        else
          log "Found #{count} space(s) before lbrace."
        end
        
        if count != @config
          @problems << Problem.new(:spaces_before_lbrace, lineno, column,
            { actual_spaces: count, should_have: @config })
        end
      end
    end
  end
end
