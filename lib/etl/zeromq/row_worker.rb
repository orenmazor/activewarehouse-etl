require 'ffi-rzmq'
require 'bert'

module ETL
  class RowWorker

    attr_accessor :ready
    def initialize(context, id)
      @run = true
      @ready = false
      working_thread = Thread.new(@run) do
        @receiver = context.socket(ZMQ::PULL)
        @receiver.connect("tcp://127.0.0.1:5557")

        @collector = context.socket(ZMQ::PUSH)
        @collector.connect("tcp://127.0.0.1:5558")

        @ready = true
        @id = id

        while @run
          result = @receiver.recv_string(message='')
          raw_row = BERT.decode(message)
          processed_row = [1,2,3,4,5]
          #when done, push it along
          @collector.send_string(BERT.encode(processed_row))
        end

        @receiver.close()
        @collector.close()
      end
    end

    def terminate
      @run = false

      #wait until this thread is done before returning
      @working_thread.join unless @working_thread.nil?
    end
  end
end