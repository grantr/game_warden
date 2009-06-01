configure do |config|
  config.servers = ["127.0.0.1:2181"]
  #config.prefix = "/gamewarden"
end

register "/memcached", "memcached servers"

watch "/memcached" do
  on :children_changed do |event|
    puts "children changed to #{event.nodes.inspect}"
    # update dna with new child list
    # run chef
  end
end


maintain "/memcached/server", :sequence => true do
  "127.0.0.1:1024"
end

#maintain "/memcached/127.0.0.1:1024"
