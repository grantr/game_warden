require 'config_builder'
require 'configuration'
require 'delegating_watcher'
require 'event_context'
require 'vendor/zookeeper/lib/zookeeper'

module GameWarden
  def self.run(config_filename)
    config_file = File.open(config_filename)
    builder = ConfigBuilder.new(config_file.read)
    sleep
  end
end
