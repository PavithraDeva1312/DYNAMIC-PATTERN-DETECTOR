module dynamicfsm(clk,rst,d_in,pattern_to_detect,p_d);
input clk,rst,d_in;
input [3:0] pattern_to_detect;  
output reg p_d;

reg  [3:0] pattern_collected;
wire [3:0] collected_now = {pattern_collected[2:0], d_in};

parameter S_NOMATCH     = 5'b00001;
parameter S_DET_0TH_BIT = 5'b00010;
parameter S_DET_1ST_BIT = 5'b00100;
parameter S_DET_2ND_BIT = 5'b01000;
parameter S_DET_3RD_BIT = 5'b10000;

reg [4:0] state, next_state;


always @(posedge clk) begin
  if (rst) begin
    state             <= S_NOMATCH;
    pattern_collected <= 4'b0000;
  end
  else begin
    state             <= next_state;
    pattern_collected <= collected_now;
  end
end


always @(*) begin
  next_state = S_NOMATCH; 
  p_d        = 1'b0;

  case (state)

    S_NOMATCH : begin
      if (d_in == pattern_to_detect[3])
        next_state = S_DET_0TH_BIT;
      else
        next_state = S_NOMATCH;
    end

    S_DET_0TH_BIT : begin
      if (collected_now[1:0] == pattern_to_detect[3:2])
        next_state = S_DET_1ST_BIT;
      else if (d_in == pattern_to_detect[3])
        next_state = S_DET_0TH_BIT;
      else
        next_state = S_NOMATCH;
    end

    S_DET_1ST_BIT : begin
      if (collected_now[2:0] == pattern_to_detect[3:1])
        next_state = S_DET_2ND_BIT;
      else if (collected_now[1:0] == pattern_to_detect[3:2])
        next_state = S_DET_1ST_BIT;
      else if (d_in == pattern_to_detect[3])
        next_state = S_DET_0TH_BIT;
      else
        next_state = S_NOMATCH;
    end

    S_DET_2ND_BIT : begin
      if (collected_now == pattern_to_detect)
        next_state = S_DET_3RD_BIT;
      else if (collected_now[2:0] == pattern_to_detect[3:1])
        next_state = S_DET_2ND_BIT;
      else if (collected_now[1:0] == pattern_to_detect[3:2])
        next_state = S_DET_1ST_BIT;
      else if (d_in == pattern_to_detect[3])
        next_state = S_DET_0TH_BIT;
      else
        next_state = S_NOMATCH;
    end

    S_DET_3RD_BIT : begin
      p_d = 1'b1;       
      if (collected_now == pattern_to_detect)
        next_state = S_DET_3RD_BIT;
      else if (collected_now[2:0] == pattern_to_detect[3:1])
        next_state = S_DET_2ND_BIT;
      else if (collected_now[1:0] == pattern_to_detect[3:2])
        next_state = S_DET_1ST_BIT;
      else if (d_in == pattern_to_detect[3])
        next_state = S_DET_0TH_BIT;
      else
        next_state = S_NOMATCH;
    end

    default : next_state = S_NOMATCH;
  endcase
end
endmodule
