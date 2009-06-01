class EventContext
  attr_accessor :nodes, :event, :type

  def initialize(event, nodes)
    @event = event
    @nodes = nodes
  end

  def node
    nodes.first
  end

  def type
    @event.type
  end
end
