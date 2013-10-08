# Steal from https://github.com/skwp/dotfiles/blob/master/irb/pryr

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

# Color Customization
# Everything below this line is for customizing colors,
# you have to use the ugly color codes, but such is life.
CodeRay.scan('example', :ruby).term
TERM_TOKEN_COLORS = {
  attribute_name: '33',
  attribute_value: '31',
  binary: '1;35',
  char: {
    self: '36', delimiter: '34'
  },
  class: '1;35',
  class_variable: '36',
  color: '32',
  comment: '37',
  complex: '34',
  constant: ['34', '4'],
  decoration: '35',
  definition: '1;32',
  directive: ['32', '4'],
  doc: '46',
  doctype: '1;30',
  doc_string: ['31', '4'],
  entity: '33',
  error: ['1;33', '41'],
  exception: '1;31',
  float: '1;35',
  function: '1;34',
  global_variable: '42',
  hex: '1;36',
  include: '33',
  integer: '1;34',
  key: '35',
  label: '1;15',
  local_variable: '33',
  octal: '1;35',
  operator_name: '1;29',
  predefined_constant: '1;36',
  predefined_type: '1;30',
  predefined: ['4', '1;34'],
  preprocessor: '36',
  pseudo_class: '34',
  regexp: {
    self: '31',
    content: '31',
    delimiter: '1;29',
    modifier: '35',
    function: '1;29'
  },
  reserved: '1;31',
  shell: {
    self: '42',
    content: '1;29',
    delimiter: '37',
  },
  string: {
    self: '36',
    modifier: '1;32',
    escape: '1;36',
    delimiter: '1;32',
  },
  symbol: '1;31',
  tag: '34',
  type: '1;34',
  value: '36',
  variable: '34',

  insert: '42',
  delete: '41',
  change: '44',
  head: '45'
}

module CodeRay
  module Encoders
    class Terminal < Encoder
      TERM_TOKEN_COLORS.each_pair do |key, value|
        TOKEN_COLORS[key] = value
      end
    end
  end
end
