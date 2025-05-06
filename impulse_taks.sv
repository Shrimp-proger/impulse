module formula #(
    parameter int WIDTH = 8
) (
    input  logic clk,
    input  logic rst_n,
    input  logic signed [WIDTH-1:0] a,
    input  logic signed [WIDTH-1:0] b,
    input  logic signed [WIDTH-1:0] c,
    input  logic signed [WIDTH-1:0] d,
    input  logic in_valid,
    output logic in_ready,
    output logic signed [WIDTH*2+2:0] q,
    output logic out_valid,
    input  logic out_ready
);

    logic stage_1_ready,stage_2_in_ready,stage_2_in_valid,stage_2_out_valid,stage_3_in_ready;
    logic signed [WIDTH*2+2:0] reg_a,reg_b,reg_c,reg_d,a_subs_b,three_c_add_1,four_d,four_d_1,mult,res;

    assign in_ready = ~stage_1_ready || in_valid;
	 
    always_ff @(posedge clk or negedge rst_n) begin

    if(!rst_n) begin

        stage_1_ready <= 0;
        q <= 0;
    end

    else begin 

      if(in_valid && in_ready) begin

        reg_a <= $signed(a);
        reg_b <= $signed(b);
        reg_c <= $signed(c);
        reg_d <= $signed(d);
        stage_1_ready <= 1; 

      end

      if(stage_1_ready) begin

        a_subs_b <= reg_a - reg_b;
        three_c_add_1 <= 1 + 3*reg_c;
        four_d <= reg_d << 2;
        stage_2_in_valid <= 1 ;

      end

      if(stage_2_in_valid && stage_2_in_ready) begin

        stage_1_ready <=0;
        stage_2_in_valid <= 0;

      end

    end

    end

    always_ff @( posedge clk or negedge rst_n ) begin

         if(!rst_n) begin

          stage_2_out_valid <= 0;
          stage_2_in_ready <= 1;

         end

         if(stage_2_out_valid == 0) begin 

          stage_2_in_ready <= 1;

         end

         if(stage_3_in_ready && stage_2_out_valid) begin

          stage_2_out_valid <= 0;

         end
         
         if(stage_2_in_valid && stage_2_in_ready) begin

          mult <= a_subs_b * three_c_add_1;
          four_d_1 <= four_d;
          stage_2_out_valid <= 1;          

         end

    end

    always_ff @( posedge clk or negedge rst_n) begin

         if(!rst_n) begin

          out_valid <= 0;
          stage_3_in_ready <= 1;

         end
         
         if(out_valid == 0) begin

          stage_3_in_ready <= 1;

         end

         if(out_valid && out_ready)begin
            out_valid <= 0;

         end

         if(stage_2_out_valid && stage_3_in_ready) begin

          q <= (mult + four_d_1) >>> 1;
          out_valid <= 1;          

         end

    end

endmodule