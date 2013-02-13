require 'ffi-rzmq'

module ETL
  class RowDistributor

    def initialize(context,num_of_workers)
      @sender = context.socket(ZMQ::PUSH)
      @sender.bind("tcp://127.0.0.1:5557")

      @workers = []
      num_of_workers.times do |idx|
        new_worker = ETL::RowWorker.new(context,idx)
        sleep(0.1) until new_worker.ready
        @workers << new_worker
      end
    end

    #this will BLOCK if there are no workers listening
    def distribute(index,row)
      @sender.send_string(BERT.encode({:index=>index,:row=>row}))
    end

    #stops the workers as soon as they are done their current task
    def stop
      @workers.each do |worker|
        worker.terminate
      end
      @sender.close
    end
  end
end