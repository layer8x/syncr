require 'listen'

module Syncr
  # Class to handle sets of listener instances
  class ListenerSet
    # [Symbol] Status for listener set.
    attr_reader :status

    # [Hash] Named listener set.
    attr_reader :listeners

    # Sets action for each listener to perform and does some inital setup
    #
    # @param initial_action [Proc] action for each listener to take (arguments are `from` and `to`)
    def initialize(&initial_action)
      @action = initial_action if initial_action

      @status = :stopped
      @listeners = Hash.new
    end

    # Gets or sets the listener action. When this changes, does not update already-created listeners' actions.
    #
    # @param replacement_action [Proc] replaces the initial_action set in #initialize
    # @return [Proc] listener action
    def action(&replacement_action)
      if replacement_action
        @action = replacement_action
      else
        @action
      end
    end

    # Adds listener to set
    #
    # @param name [Symbol, String] name to set the listener to
    # @param from [String] origin path to listen on
    # @param to [String] destination path to act upton
    def add_listener(name, from, to)
      @listeners[name] = Listen.to(from) do |modified, added, removed|
        log "modified absolute path: #{modified}"
        log "added absolute path: #{added}"
        log "removed absolute path: #{removed}"
        @action.call(from, to)
      end
    end

    # Remove listener from set
    # @param name [Symbol, String] name of listener to remove
    def remove_listener(name)
      @listeners.delete name
    end

    # Starts all listeners
    #
    # @return [Symbol] current status
    def start
      on_each_listener(:start)
      @status = :started
    end

    # Stops all listeners
    #
    # @return [Symbol] current status
    def stop
      on_each_listener(:stop)
      @status = :stopped
    end

    # Are listeners started?
    #
    # @return [Boolean] true if started, false if not
    def started?
      @status == :started
    end

    # Are listeners stopped?
    #
    # @return [Boolean] true if stopped, false if not
    def stopped?
      @status == :stopped
    end

    # Number of listeners in set
    #
    # @return [Integer] size of listeners hash
    def size
      listeners.size
    end
    alias_method :length, :size

  private

    # TODO: Extract to Logger module
    def log(m)
      puts "#{Time.now.strftime("%F %T")}> #{m}"
    end

    def on_each_listener(action)
      @listeners.each { |name, listener| listener.send(action) }
    end
  end
end
