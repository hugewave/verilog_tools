module gather_distributer (
    input clk,
    input rst,
    input [7:0] data_in,
    input data_in_valid,
    input sop_in,
    input eop_in,
    output [7:0] data_out,
    output reg data_out_valid,
    output reg sop_out,
    output reg eop_out
);

localparam IDLE = 0;
localparam WRITE_TO_BUFFER = 1;
localparam READ_OUT = 2;

reg [2:0] current_state, next_state;
reg [7:0] write_ptr;
reg [7:0] read_ptr;
always @(posedge clk or posedge rst) begin
    if(reset) begin
        current_state <= IDLE;
        read_ptr <= 0;
        write_ptr <= 0;
    end 
    else begin
        case(current_state)
            IDLE: begin
                if(sop_in && data_in_valid) begin
                    next_state <= WRITE_TO_BUFFER;
                    buffer[0] <= data_in; 
                    write_ptr <= 1;
                end 
                else begin
                    next_state <= IDLE;
                    read_ptr <= 0;
                    write_ptr <= 0;
                end
            end
            WRITE_TO_BUFFER: begin
                if(data_in_valid)begin
                    if(eop_in) begin
                        next_state <= READ_OUT_EOP;
                        buffer[write_ptr] <= data_in;
                        read_ptr <= 0;
                    end
                    else begin
                        if(sop_in) begin
                            next_state <= IDLE;
                            write_ptr <= 0;
                            read_ptr <= 0;
                        end
                        else begin
                            next_state <= WRITE_TO_BUFFER;
                            buffer[write_ptr] <= data_in;
                            write_ptr <= write_ptr + 1;
                        end
                    end
                end
            end
            READ_OUT: begin
                if(read_ptr == write_ptr) begin
                    next_state <= IDLE;
                end 
                else begin
                    next_state <= READ_OUT;
                end
                data_out <= buffer[read_ptr];
                read_ptr <= read_ptr + 1;
                if(read_ptr == 0) begin
                    sop_out <= 1;
                end 
                else begin
                    sop_out <= 0;
                end
                if(read_ptr == write_ptr) begin
                    eop_out <= 1;
                end 
                else begin
                    eop_out <= 0;
                end
            end

            default: next_state <= IDLE;
        current_state <= next_state;
    end 
end

always @(posedge clk or posedge rst) begin
    if(reset) begin
        data_out_valid <= 0;
    end 
    else begin
        case(current_state)
            IDLE: begin
                data_out_valid <= 0;
            end
            WRITE_TO_BUFFER: begin
                data_out_valid <= 0;
            end
            READ_OUT: begin
                data_out_valid <= 1;
            end
            default: data_out_valid <= 0;
        endcase
    end
end

endmodule