
module RackCloud

end

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../../datapathy/lib"))
require 'datapathy'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../../../../personal/resourceful/lib"))
require 'resourceful'

require 'json'

require File.join(File.dirname(__FILE__), 'datapathy', 'adapter')
require File.join(File.dirname(__FILE__), 'rackcloud', 'models', 'server')

require 'yaml'
config = YAML.load_file(File.expand_path("~/.rackcloud.yml"))
user, key = config["user"], config["key"]

Datapathy.default_adapter = RackCloud::DatapathyRackCloudAdapter.new(:user => user, :key => key)
