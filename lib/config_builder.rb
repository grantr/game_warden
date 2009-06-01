class ConfigBuilder
  attr_accessor :config

  def initialize(config="", &block)
    if block_given?
      instance_eval(&block)
    else
      instance_eval(config)
    end
  end

  def configure(&block)
    @config = Configuration.new
    yield @config
    raise "server list required" if @config.servers.empty?
    @config.zookeeper = ZooKeeper.new(:host => @config.servers.join(","), :watcher => @config.watcher)
  end

  def watch(path, &block)
    raise_unless_config
    WatchContext.new(config, path, &block)
  end

  def register(*args)
    raise_unless_config
    options = args.last.is_a?(Hash) ? args.pop : {}
    path, data = *args
    data = yield if block_given?
    unless config.zookeeper.exists(path)
      config.zookeeper.create options.merge(:path => path, :data => data)
    end
  end

  def maintain(path, data=nil, options={}, &block)
    raise_unless_config
    register(path, data, {:ephemeral => true}, &block)
  end

  def raise_unless_config
    raise "configure block must be first" unless @config
  end

  class WatchContext
    def initialize(config, path, &block)
      @config = config
      @path = path
      instance_eval(&block)
    end

    def on(events, options={}, &block)
      @config.watcher.add_watch(@path, events, block) 
    end
  end
end
