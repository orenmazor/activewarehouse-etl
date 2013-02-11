require 'ffi-rzmq'

module ETL
  class RowDistributor

    def initialize
      context = ZMQ::Context.new
      @sender = context.socket(ZMQ::PUSH)
      @sender.bind("tcp://*:5557")
    end

    def distribute(index,row)
      @sender.send_string(BERT.encode({:index=>index,:row=>row}))
    end
  end
end