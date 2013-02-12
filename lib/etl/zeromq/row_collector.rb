require 'ffi-rzmq'

module ETL
  class RowCollector
    def initialize(context)
      @receiver = context.socket(ZMQ::PULL)
      @receiver.bind("tcp://*:5558")
    end

    def collect(num_of_rows)
    end
  end
end