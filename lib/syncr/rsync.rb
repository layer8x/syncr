module Syncr
  # Class to handle making calls to rsync executable
  class Rsync
    # Calls system rsync with options
    # Can be called using DSL syntax `rsync '/some/path', to: '/another/path'` or just `rsync '/some/path', '/another/path'`
    #
    # @param from [String] origin path
    # @param target_options [String, Hash] destination path
    def self.rsync(from, target_options)
      # Check if rsync is installed and return that path
      system_rsync_path = `which rsync`.strip
      raise RsyncNotInstalledError unless $?.exitstatus == 0

      to = target_options.is_a?(Hash) ? target_options[:to] : target_options
      system("#{system_rsync_path} -avzh #{from} #{to}")
    end

    # Forwards to Syncr::Rsync::rsync. See Syncr::Rsync::rsync
    def rsync(*args)
      self.class.rsync(*args)
    end
    alias_method :call, :rsync
  end

  RsyncNotInstalledError = Class.new(StandardError)
end
