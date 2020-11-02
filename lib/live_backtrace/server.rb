require 'socket'
require 'json'
require 'rainbow'
require 'pathname'
require 'rouge'

gs = TCPServer.new("127.0.0.1", 9998)
addr = gs.addr
addr.shift            # removes "AF_INET"
puts("Live backtrace server running on #{addr[2]}:#{addr[0]}")

loop do
  Thread.start(gs.accept) do |s|
    while line = s.gets
      hashed = JSON.parse(line)
      print Rainbow("#{hashed['class']}").green
      print "::"
      print Rainbow("#{hashed['method']}").blue
      print "("
      param_string = ""
      hashed['params'].each do |p|
        param_string << Rainbow("#{p['name']}").cyan
        param_string << "="
        param_string << Rainbow("#{p['param_value']}").yellow
        param_string << ", "
      end
      param_string = param_string[0..-3]
      print param_string
      print ") => "
      puts "#{hashed['path']}:#{hashed['lineno']}"
      puts "\n"

      context = hashed['context']
      line = hashed['caller']

      context.each_with_index do |l, i|
        context[i] = '   -> ' + l if l == line
        context[i] = '      ' + l if l != line
      end
      formatter = Rouge::Formatters::Terminal256.new
      lexer = Rouge::Lexers::Shell.new
      puts(formatter.format(lexer.lex(context.join)))
    end
    s.close
  end
end
