require "syncr/listener_set"
require "syncr/rsync"

module Syncr
  # Listens for file changes and rsyncs automatically
  class Listener < Rsync
    # Instantiates and starts new Listener instance. See #initialize for arguments.
    def self.start(*args)
      listener = new(*args)
      listener.start
      listener
    end

    # [ListenerSet] Currently used instance of ListenerSet
    attr_reader :listeners

    # [Hash] Options
    attr_accessor :options

    # Does some option checking (throws ArgumentError if there isn't a local and external directory specified) and sets up stuff
    #
    # @param option [Hash] Options. Required: :local, :external
    def initialize(options={})
      raise ArgumentError, "Requires local and external directories to sync" unless options[:local] && options[:external]
      @options = options

      @listeners = ListenerSet.new do |from, to|
        rsync from, to
      end

      @listeners.add_listener(:local, options[:local], options[:external])
      @listeners.add_listener(:external, options[:external], options[:local]) if options[:two_way_sync]
    end

    # Forwards to Syncr::Rsync::rsync. See Syncr::Rsync::rsync
    def rsync(*args)
      Rsync.rsync(*args)
    end

    # Starts listeners in listener set
    def start
      @listeners.start
    end

    # Stops listeners in listener set
    def stop
      @listeners.stop
    end
  private
    # TODO: Extract to Logger module
    def log(m)
      puts "#{Time.now.strftime("%F %T")}> #{m}"
    end
  end
end
