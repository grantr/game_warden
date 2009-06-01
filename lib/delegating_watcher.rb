class DelegatingWatcher
  attr_accessor :watchers, :config

  def initialize(config)
    @watchers = {}
    @config = config
  end

  def add_watch(path, events, proc)
    Array(events).each do |event|
      event_type = event_symbol_to_zk(event)
      @watchers[[path, event_type]] = proc
      watch_event(path, event_type)
    end
  end

  def process(event)
    puts "processing: #{event.inspect}"
    if proc = @watchers[[event.path, event.type]]
      begin
        nodes = get_nodes_for_event(event)
        proc.call EventContext.new(event, nodes)
      ensure
        watch_event(event.path, event.type)
      end
    end
  end

  private
  def event_symbol_to_zk(event)
    case event
    when :none
      ZooKeeper::WatcherEvent::EventNone
    when :node_created
      ZooKeeper::WatcherEvent::EventNodeCreated
    when :node_deleted
      ZooKeeper::WatcherEvent::EventNodeDeleted
    when :data_changed
      ZooKeeper::WatcherEvent::EventNodeDataChanged
    when :children_changed
      ZooKeeper::WatcherEvent::EventNodeChildrenChanged
    end
  end

  def get_nodes_for_event(event)
    case event.type
    when ZooKeeper::WatcherEvent::EventNodeChildrenChanged
      config.zookeeper.children(event.path)
    else
      [event.path]
    end
  end

  def watch_event(path, type)
    case type
    when ZooKeeper::WatcherEvent::EventNodeCreated, ZooKeeper::WatcherEvent::EventNodeDeleted
      config.zookeeper.exists(:path => path, :watch => true)
    when ZooKeeper::WatcherEvent::EventNodeDataChanged
      config.zookeeper.get(:path => path, :watch => true)
    when ZooKeeper::WatcherEvent::EventNodeChildrenChanged
      config.zookeeper.children(:path => path, :watch => true)
    end
  end
end
