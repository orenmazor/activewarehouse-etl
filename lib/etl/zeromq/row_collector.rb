require 'ffi-rzmq'
require 'bert'

module ETL
  class RowCollector

    def initialize(context)
      @collected_rows = []
      @run = true
      @rows_read = 0
      @collector_thread = Thread.new do
        receiver = context.socket(ZMQ::PULL)
        receiver.bind("tcp://127.0.0.1:5558")

        while @run
          res = receiver.recv_string(message = '',ZMQ::NonBlocking)
          if res > -1
            decoded_row = BERT.decode(message)
            @collected_rows << decoded_row
          end
        end

        receiver.close
      end
    end

    def workers_available

    end

    def finish
      @run = false
      @collector_thread.join unless @collector_thread.nil?
      @collected_rows
    end
  end
end