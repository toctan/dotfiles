# Steal from https://github.com/skwp/dotfiles/blob/master/irb/pryrc

# Editor
Pry.editor = ENV['EDITOR']

# Pry-Nav
Pry.commands.alias_command 'c', 'continue' rescue nil
Pry.commands.alias_command 's', 'step' rescue nil
Pry.commands.alias_command 'n', 'next' rescue nil

# Prompt
# This prompt shows the ruby version (useful for RVM)
Pry.prompt = [
  proc { |obj, nest_level, _| "#{RUBY_VERSION} (#{obj}):#{nest_level} > " },
  proc { |obj, nest_level, _| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " }
]

# awesome_print
# look at ~/.aprc for more settings for awesome_print
begin
  require 'awesome_print'
  Pry.config.print = proc do |output, value|
    Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output)
  end
rescue LoadError
  puts 'gem install awesome_print  # <-- highly recommended'
end

# Custom Commands
# from: https://gist.github.com/1297510

default_command_set = Pry::CommandSet.new do
  command 'copy', 'Copy argument to the clip-board' do |str|
    clipboard = %w(pbcopy xclip xsel).find do |cmd|
      system "which #{cmd} > /dev/null"
    end

    IO.popen(clipboard, 'w') { |f| f << str.to_s }
  end

  command 'clear' do
    system 'clear'
    output.puts "Rails Environment: #{ENV['RAILS_ENV']}" if ENV['RAILS_ENV']
  end

  command 'sql', 'Send sql over AR.' do |query|
    if ENV['RAILS_ENV'] || defined?(Rails)
      pp ActiveRecord::Base.connection.select_all(query)
    else
      pp 'No rails env defined'
    end
  end

  command 'caller_method' do |depth|
    depth = depth.to_i || 1
    if /^(.+?):(\d+)(?::in `(.*)')?/ =~ caller(depth + 1).first
      file   = Regexp.last_match[1]
      line   = Regexp.last_match[2].to_i
      method = Regexp.last_match[3]
      output.puts [file, line, method]
    end
  end
end

Pry.config.commands.import default_command_set

# Convenience Methods
# Stolen from https://gist.github.com/807492
class Array
  def self.toy(n = 10, &block)
    block_given? ? Array.new(n, &block) : Array.new(n) { |i| i + 1 }
  end
end

class Hash
  def self.toy(n = 10)
    Hash[Array.toy(n).zip(Array.toy(n) { |c| ( 96 + (c + 1)).chr })]
  end
end
