require 'ffi-rzmq'

module ETL
  class RowWorker

    def initialize(context, id, collector_socket)
      @receiver = context.socket(ZMQ::PULL)
      @receiver.connect("tcp://localhost:5557")

      @collector_socket = collector_socket
    end

    def work(id)
    end
  end
end