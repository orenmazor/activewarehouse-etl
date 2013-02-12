require 'ffi-rzmq'

module ETL
  class RowDistributor

    def initialize(context,num_of_workers,collector)
      @sender = context.socket(ZMQ::PUSH)
      @sender.bind("tcp://*:5557")

      @workers = []
      num_of_workers.times do |idx|
        new_worker = ETL::RowWorker.new(context,idx,collector)
        @workers << new_worker
      end

    end


    def distribute(index,row)
      @sender.send_string(BERT.encode({:index=>index,:row=>row}))
    end

    def stop
    end
  end
end