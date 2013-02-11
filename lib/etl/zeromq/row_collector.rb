require 'ffi-rzmq'

module ETL
  class RowCollector
    def initialize
      context = ZMQ::Context.new
      @receiver = context.socket(ZMQ::PULL)
      @receiver.bind("tcp://*:5558")
    end

    def collect(num_of_rows)
      #how do we handle unreceived rows?
      num_of_rows.times do |index|
        processed_row = BERT.decode(@receiver.recv_string)
      end
    end
  end
end