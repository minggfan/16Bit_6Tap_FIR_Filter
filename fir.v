// =============================================================================
// This file implements a 16-Bit 6-Tap Programmable FIR Filter.
// =============================================================================


module  fir(
	input clk,
	input rst_n,			
	input enable,
	input [2:0] tap,		// Tap No. 2-6
	input [15:0] data_in,		
	output [17:0] data_out,		
	output complete
);

localparam
a0 = 16'd1,	// Tap coefficient number
a1 = 16'd2,
a2 = 16'd2,
a3 = 16'd3,
a4 = 16'd3,
a5 = 16'd3;

reg [15:0] data_reg_0;	// Hold input data
reg [15:0] data_reg_1;
reg [15:0] data_reg_2;
reg [15:0] data_reg_3;
reg [15:0] data_reg_4;
reg [15:0] data_reg_5;
reg [15:0] multiplication_0;	// Hold result of multiplication
reg [15:0] multiplication_1;
reg [15:0] multiplication_2;
reg [15:0] multiplication_3;
reg [15:0] multiplication_4;
reg [15:0] multiplication_5;

reg [16:0] sum_1;	// Hold sum of data
reg [16:0] sum_2;
reg [16:0] sum_3;

reg [17:0] result; // Hold result

reg mul_stage, add_stage1, add_stage2, output_stage;	// Pipeline Stage


//Pipeline
always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        	begin
        		mul_stage <= 1'b0;
        		add_stage1 <= 1'b0;
        		add_stage2 <= 1'b0;
				output_stage <= 1'b0;
        	end
        else
        	begin
        			mul_stage <= enable;
        			add_stage1 <= mul_stage;
        			add_stage2 <= add_stage1;
        			output_stage <= add_stage2;
        	end
    end

//Data Loading
always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        	begin
        		data_reg_0 <= 0;
        		data_reg_1 <= 0;
        		data_reg_2 <= 0;
        		data_reg_3 <= 0;
			data_reg_4 <= 0;
        		data_reg_5 <= 0;
        	end
        else
        	begin
				case (tap)
					3'd2:
					begin
						if (enable) 
							begin
								data_reg_0 <= data_in;
								data_reg_1 <= data_reg_0;
							end
						else 
							begin
								data_reg_0 <= data_reg_0;
								data_reg_1 <= data_reg_1;
							end
					end
					3'd3:
					begin
						if (enable) 
							begin
								data_reg_0 <= data_in;
								data_reg_1 <= data_reg_0;
								data_reg_2 <= data_reg_1;
							end
						else 
							begin
								data_reg_0 <= data_reg_0;
								data_reg_1 <= data_reg_1;
								data_reg_2 <= data_reg_2;
							end
					end
					3'd4:
					begin
						if (enable) 
							begin
								data_reg_0 <= data_in;
								data_reg_1 <= data_reg_0;
								data_reg_2 <= data_reg_1;
								data_reg_3 <= data_reg_2;
							end
						else 
							begin
								data_reg_0 <= data_reg_0;
								data_reg_1 <= data_reg_1;
								data_reg_2 <= data_reg_2;
								data_reg_3 <= data_reg_3;
							end
					end
					3'd5:
					begin
						if (enable) 
							begin
								data_reg_0 <= data_in;
								data_reg_1 <= data_reg_0;
								data_reg_2 <= data_reg_1;
								data_reg_3 <= data_reg_2;
								data_reg_4 <= data_reg_3;
							end
						else 
							begin
								data_reg_0 <= data_reg_0;
								data_reg_1 <= data_reg_1;
								data_reg_2 <= data_reg_2;
								data_reg_3 <= data_reg_3;
								data_reg_4 <= data_reg_4;
							end
					end
					3'd6:
					begin
						if (enable) 
							begin
								data_reg_0 <= data_in;
								data_reg_1 <= data_reg_0;
								data_reg_2 <= data_reg_1;
								data_reg_3 <= data_reg_2;
								data_reg_4 <= data_reg_3;
								data_reg_5 <= data_reg_4;
							end
						else 
							begin
								data_reg_0 <= data_reg_0;
								data_reg_1 <= data_reg_1;
								data_reg_2 <= data_reg_2;
								data_reg_3 <= data_reg_3;
								data_reg_4 <= data_reg_4;
								data_reg_5 <= data_reg_5;
							end
					end
				endcase
        	end
    end

//Data Multiplication
always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        	begin
        		multiplication_0 <= 0;
        		multiplication_1 <= 0;
        		multiplication_2 <= 0;
        		multiplication_3 <= 0;
			multiplication_4 <= 0;
        		multiplication_5 <= 0;
        	end
        else
        	begin
				case (tap)
					3'd2:
					begin
						if(mul_stage)
							begin
								multiplication_0 <= a0 * data_reg_0;
								multiplication_1 <= a1 * data_reg_1;
							end
						else 
							begin
								multiplication_0 <= multiplication_0;
								multiplication_1 <= multiplication_1;
							end
					end
					3'd3:
					begin
						if(mul_stage)
							begin
								multiplication_0 <= a0 * data_reg_0;
								multiplication_1 <= a1 * data_reg_1;
								multiplication_2 <= a2 * data_reg_2;
							end
						else 
							begin
								multiplication_0 <= multiplication_0;
								multiplication_1 <= multiplication_1;
								multiplication_2 <= multiplication_2;
							end
					end
					3'd4:
					begin
						if(mul_stage)
							begin
								multiplication_0 <= a0 * data_reg_0;
								multiplication_1 <= a1 * data_reg_1;
								multiplication_2 <= a2 * data_reg_2;
								multiplication_3 <= a3 * data_reg_3;
							end
						else 
							begin
								multiplication_0 <= multiplication_0;
								multiplication_1 <= multiplication_1;
								multiplication_2 <= multiplication_2;
								multiplication_3 <= multiplication_3;
							end
					end
					3'd5:
					begin
						if(mul_stage)
							begin
								multiplication_0 <= a0 * data_reg_0;
								multiplication_1 <= a1 * data_reg_1;
								multiplication_2 <= a2 * data_reg_2;
								multiplication_3 <= a3 * data_reg_3;
								multiplication_4 <= a4 * data_reg_4;
							end
						else 
							begin
								multiplication_0 <= multiplication_0;
								multiplication_1 <= multiplication_1;
								multiplication_2 <= multiplication_2;
								multiplication_3 <= multiplication_3;
								multiplication_4 <= multiplication_4;
							end
					end
					3'd6:
					begin
						if(mul_stage)
							begin
								multiplication_0 <= a0 * data_reg_0;
								multiplication_1 <= a1 * data_reg_1;
								multiplication_2 <= a2 * data_reg_2;
								multiplication_3 <= a3 * data_reg_3;
								multiplication_4 <= a4 * data_reg_4;
								multiplication_5 <= a5 * data_reg_5;
							end
						else 
							begin
								multiplication_0 <= multiplication_0;
								multiplication_1 <= multiplication_1;
								multiplication_2 <= multiplication_2;
								multiplication_3 <= multiplication_3;
								multiplication_4 <= multiplication_4;
								multiplication_5 <= multiplication_5;
							end
					end
				endcase
        	end
    end

//Addition
always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        	begin
        		sum_1 <= 0;
        		sum_2 <= 0;
			sum_3 <= 0;
        	end
        else
        	begin
				case (tap)
					3'd2:
					begin
						if (add_stage1) 
							begin
								sum_1 <= multiplication_0 + multiplication_1;
								sum_2 <= 0;
							end
						else 
							begin
								sum_1 <= sum_1;
								sum_2 <= sum_2;
							end
					end
					3'd3:
					begin
						if (add_stage1) 
							begin
								sum_1 <= multiplication_0 + multiplication_1;
								sum_2 <= multiplication_2; 
							end
						else 
							begin
								sum_1 <= sum_1;
								sum_2 <= sum_2;
							end
					end
					3'd4:
					begin
						if (add_stage1) 
							begin
								sum_1 <= multiplication_0 + multiplication_1;
								sum_2 <= multiplication_2 + multiplication_3; 
							end
						else 
							begin
								sum_1 <= sum_1;
								sum_2 <= sum_2;
							end
					end
					3'd5:
					begin
						if (add_stage1) 
							begin
								sum_1 <= multiplication_0 + multiplication_1;
								sum_2 <= multiplication_2 + multiplication_3; 
								sum_3 <= multiplication_4;
							end
						else 
							begin
								sum_1 <= sum_1;
								sum_2 <= sum_2;
								sum_3 <= sum_3;
							end
					end
					3'd6:
					begin
						if (add_stage1) 
							begin
								sum_1 <= multiplication_0 + multiplication_1;
								sum_2 <= multiplication_2 + multiplication_3; 
								sum_3 <= multiplication_4 + multiplication_5; 
							end
						else 
							begin
								sum_1 <= sum_1;
								sum_2 <= sum_2;
								sum_3 <= sum_3;
							end
					end
				endcase
        	end
    end

//Sum of addition
always @ (posedge clk or negedge rst_n)
      begin
          if(!rst_n)
          	begin
          		result <= 0;
          	end
          else
          	begin
				case (tap)
					3'd2:
					begin
						if (add_stage2) 
							begin
								result <= sum_2 + sum_1;
							end
						else 
							begin
								result <= result;
							end
					end
					3'd3:
					begin
						if (add_stage2) 
							begin
								result <= sum_2 + sum_1;
							end
						else 
							begin
								result <= result;
							end
					end
					3'd4:
					begin
						if (add_stage2) 
							begin
								result <= sum_2 + sum_1;
							end
						else 
							begin
								result <= result;
							end
					end
					3'd5:
					begin
						if (add_stage2) 
							begin
								result <= sum_2 + sum_1;
								result <= result + sum_3;
							end
						else 
							begin
								result <= result;
							end
					end
					3'd6:
					begin
						if (add_stage2) 
							begin
								result <= sum_2 + sum_1;
								result <= result + sum_3;
							end
						else 
							begin
								result <= result;
							end
					end
				endcase
          	end
      end

assign data_out = result;	// Final result
assign complete = output_stage;

endmodule