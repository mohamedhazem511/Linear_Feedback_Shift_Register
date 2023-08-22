
//********** inputs and outputs ports decleration *************//

module Door_Controller(
input   wire     CLK,
input   wire     RST,
input   wire     Activate,
input   wire     UP_MAX,
input   wire     DOWN_MAX,
output  reg      UP_M,
output  reg      DOWN_M
);


//********** FSM Encoding ************//

localparam      IDLE    = 2'b00,
                Mv_Up   = 2'b01,
                Mv_Dn   = 2'b10;
                
//********** internal signal ************//

reg  [1:0]      Current_State, Next_State;


//********** Active Low Asynchronous Rest and State transition ************//

always @(posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
     Current_State <= IDLE ;
   end
  else
   begin
     Current_State <= Next_State ;
   end
end

 
 //********** Next State Logic ************//
 
 
always @ (*)
  begin
    case(Current_State)
     IDLE: begin
            if( Activate && DOWN_MAX && !UP_MAX )
              begin
             Next_State = Mv_Up;
           end
            else if(Activate && !DOWN_MAX && UP_MAX )
              begin
             Next_State = Mv_Dn;
           end
            else
              begin
             Next_State = IDLE;
           end
            end
    Mv_Up: begin
            if(UP_MAX)
              begin
             Next_State = IDLE;
           end
            else
              begin
             Next_State = Mv_Up;
              end
            end
    Mv_Dn: begin
            if(DOWN_MAX)
              begin
             Next_State = IDLE;
             end
            else
              begin
             Next_State = Mv_Dn;
           end
            end
    default: begin
             Next_State = IDLE;
             end         
           
  endcase
end
  
  //********** Output Logic ************//
  
always @(*)
 begin
  UP_M    = 1'b0;
  DOWN_M  = 1'b0;
  
   case (Current_State)
   IDLE   :  begin
            UP_M = 1'b0 ;
            DOWN_M = 1'b0 ;
             end
   Mv_Up  :  begin
            UP_M = 1'b1 ;
             end
   Mv_Dn  :  begin
            DOWN_M = 1'b1 ;
             end
   default:  begin
            UP_M = 1'b0 ;
            DOWN_M = 1'b0 ;
             end  
   endcase
   
 end
   
 endmodule                          