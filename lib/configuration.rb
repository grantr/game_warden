class Configuration
  attr_accessor :prefix, :zookeeper, :servers, :watcher

  def initialize
    @prefix = ""
    @watcher = DelegatingWatcher.new(self)
    @servers = []
  end
end
