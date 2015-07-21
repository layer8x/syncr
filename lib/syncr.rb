require "syncr/version"
require "syncr/listener_set"

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

  def initialize(options={})
    raise ArgumentError, "Requires local and external directories to sync" unless options[:local] && options[:external]
    @options = options

    @listeners = ListenerSet.new do |from, to|
      rsync from, to
    end

    @listeners.add_listener(:local, options[:local], options[:external])
    @listeners.add_listener(:external, options[:external], options[:local]) if options[:two_way_sync]
  end

  def rsync(*args)
    self.class.rsync(*args)
  end

  def start
    @listeners.start
  end

  def stop
    @listeners.stop
  end
private
  def log(m)
    puts "#{Time.now.strftime("%F %T")}> #{m}"
  end
end
