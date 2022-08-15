module stop_check #(parameter PRESCALE_WIDTH = 6) (
    input   wire                                stp_chk_en,
    input   wire                                sampled_bit,
    input   wire    [4:0]                       edge_cnt,
    input   wire    [PRESCALE_WIDTH - 1 : 0]    prescale, 
    input   wire                                CLK,
    input   wire                                RST,

    output  reg                                 stp_err
);


    reg [4:0]   sampling_time;
//we check at 6th edge count for prescale = 8 
//or 10th for prescale 16
//or 18th for prescale 32
    always @(*) begin
        case (prescale)
            6'd8:     sampling_time <= 5'd6;
            6'd16:    sampling_time <= 5'd10;
            6'd32:    sampling_time <= 5'd18;
            default:  sampling_time <= 5'd6;
        endcase
    end

    always @(posedge CLK, negedge RST) begin
        if(!RST)
            begin
                stp_err <= 1'b0;
            end
        else    begin
            if(stp_chk_en)
                begin
                    if(edge_cnt == sampling_time)
                        begin
                            if(sampled_bit == 1'b1)
                                stp_err <= 1'b0;
                            else
                                stp_err <= 1'b1;
                        end
                    else 
                        begin
                            stp_err <= stp_err;
                        end
                end
            else    
                begin
                    stp_err <= 1'b0;
                end
        end
    end


endmodule