require "syncr/version"
require 'listen'

class Syncr
  class << self
    def rsync(from, target_options)
      to = target_options.is_a?(Hash) ? target_options[:to] : target_options
      system("rsync -avzh #{from} #{to}")
    end

    def start(*args)
      self.class.new(*args).start
    end
  end

  attr_reader :listeners
  attr_accessor :options

  [:local, :external].each do |type|
    define_method("#{type}_directory".intern) { options[type] }
    define_method("#{type}_directory=".intern) { |new_dir| options[type] = new_dir }
  end

  def initialize(options={})
    raise ArgumentError, "Requires local and external directories to sync" unless options[:local] && options[:external]
    @options = options
    @listeners = {}
    @listeners[:local] = Listen.to(options[:local], &listen_callback(options[:local], options[:external]))
    @listeners[:external] = Listen.to(options[:external], &listen_callback(options[:external], options[:local])) if options[:two_way_sync]
  end

  def rsync(*args)
    self.class.rsync(*args)
  end

  def start
    listeners.each { |name, listener| listener.start }
  end

  def stop
    listeners.each { |name, listener| listener.stop }
  end
private
  def listen_callback(*args)
    Proc.new do |modified, added, removed|
      log "modified absolute path: #{modified}"
      log "added absolute path: #{added}"
      log "removed absolute path: #{removed}"
      rsync args.first, to: args.last
    end
  end

  def log(m)
    puts "#{Time.now.strftime("%F %T")}> #{m}"
  end
end
