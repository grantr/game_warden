# configure block has to be first
# servers is an array of zk servers; required
configure do |config|
  config.servers = ["127.0.0.1:2181"]
  #config.prefix = "/gamewarden"
end

# register creates a node if it doesn't exist
# must be before any watch blocks referencing this node
# params are path, data
register "/memcached", "memcached servers"

# watch a node for events
watch "/memcached" do

  on :children_changed do |event|
    puts "children changed to #{event.nodes.inspect}"
    # update dna with new child list
    # run chef
  end

  on [:node_deleted, :node_created] do |event|
    puts "node state changed"
  end
end

# create an ephemeral node
# sequence optional
# data is result of block
maintain "/memcached/server", :sequence => true do
  "127.0.0.1:1024"
end

# can also pass data as an argument
#maintain "/memcached/127.0.0.1:1024", "data"
