
class Server
  include Datapathy::Model

  persists :id, :name, :imageId, :flavorId, :hostId, :status, :metadata, :addresses, :progress

end
