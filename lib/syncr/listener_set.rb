require 'listen'

class Syncr::ListenerSet
  attr_reader :status
  attr_reader :listeners

  def initialize(&initial_action)
    @action = initial_action if initial_action

    @status = :stopped
    @listeners = Hash.new
  end

  def action(&replacement_action)
    if replacement_action
      @action = replacement_action
    else
      @action
    end
  end

  def add_listener(name, from, to)
    @listeners[name] = Listen.to(from) do |modified, added, removed|
      log "modified absolute path: #{modified}"
      log "added absolute path: #{added}"
      log "removed absolute path: #{removed}"
      @action.call(from, to)
    end
  end

  def remove_listener(name)
    @listeners.delete name
  end

  def start
    on_each_listener(:start)
    @status = :started
  end

  def stop
    on_each_listener(:stop)
    @status = :stopped
  end

  def started?
    @status == :started
  end

  def stopped?
    @status == :stopped
  end

  def size
    listeners.size
  end

private
  def log(m)
    puts "#{Time.now.strftime("%F %T")}> #{m}"
  end

  def on_each_listener(action)
    @listeners.each { |name, listener| listener.send(action) }
  end
end
