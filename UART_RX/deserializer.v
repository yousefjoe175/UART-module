module deserializer #(parameter WIDTH = 8, PRESCALE_WIDTH = 6)(
    input   wire                                sampled_bit,
    input   wire    [3:0]                       bit_cnt,
    input   wire    [4:0]                       edge_cnt,
    input   wire    [PRESCALE_WIDTH - 1 : 0]    prescale,
    input   wire                                CLK,
    input   wire                                RST,
    input   wire                                deser_en,

    output  reg     [WIDTH - 1 : 0]             P_data

);


    always @(posedge CLK, negedge RST) begin
        if(!RST)
            P_data <= 8'b0;
        else    begin
            if(deser_en && edge_cnt == prescale - 1)
                begin
                    P_data[bit_cnt - 1] <= sampled_bit;
                end
            else
                P_data[bit_cnt - 1] <= P_data[bit_cnt - 1];
        end
    end
    
endmodule