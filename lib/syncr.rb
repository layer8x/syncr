require "syncr/version"
require "syncr/listener"

module Syncr
  extend self
  # Forwards to Syncr::Rsync::rsync. See Syncr::Rsync::rsync
  def rsync(*args)
    Rsync.rsync(*args)
  end

  # Deprecated. See Syncr::Listener::start
  def start(*args)
    deprecated "Syncr::start", "Syncr::Listener::start"
    Listener.new(*args).start
  end

  # Deprecated. See Syncr::Listener#initialize
  def new(*args)
    deprecated "Syncr#initialize", "Syncr::Listener#initialize"
    Listener.new(*args)
  end

  def listen(*args)
    Listener.new(*args).start
  end

  # Deprecated output helper thing
  def deprecated(old, new)
    STDERR.puts "WARNING: #{old} is deprecated. Use #{new}"
  end
end
