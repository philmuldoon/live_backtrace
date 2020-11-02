require "pathname"
require 'json'

  # Blah for now
class Trace
  def self.trace!
    trace ||= TracePoint.new(:call) do |tp|
      unless trace_matches_elided?(tp.path)
        payload = assemble_frame(tp)
        transmit(payload)
      end
    end
    trace.enable
  end

  def self.trace_matches_elided?(path)
    gems_paths = (Gem.path | [Gem.default_dir]).map { |p| Regexp.escape(p) }
    gems_regexp = %r{(#{gems_paths.join('|')})/(bundler/)?gems/([^/]+)-([\w.]+)/(.*)}
    ruby_regexp = %r{<internal.*|\.rubies.*}
    path.match(gems_regexp) || path.match(ruby_regexp)
  end

  def self.assemble_frame(tp)
    payload = { type: tp.event }
    payload[:class] = tp.defined_class
    payload[:method] = tp.callee_id
    payload[:path] = tp.path
    payload[:lineno] = tp.lineno
    lineno = caller_locations.last.lineno
    lines = File.open(caller_locations.last.absolute_path).to_a
    payload[:context] = lines[lineno - 3..lineno + 3] # a range of lines
    payload[:caller] = lines[lineno - 1] # a range of li
    payload[:params] = assemble_frame_args(tp)
    payload
  end

  def self.transmit(payload)
    s = TCPSocket.new '127.0.0.1', 9998
    s.puts(JSON.generate(payload))
    s.close
  end

  def self.assemble_frame_args(tp)
    payload_params = []
    tp.parameters.each do |n|
      param_item = {}
      param_item[:name] = n[1]
      value = tp.binding.eval(n[1].to_s)
      param_item[:param_value] = value
      payload_params << param_item
    end
    payload_params
  end

  def self.extract_arguments(trace)
    param_names = trace.parameters.map(&:last)
    param_names.map { |n| [n, trace.binding.eval(n.to_s)] }.to_h
  end
end
