

//********** inputs and outputs ports decleration *************//

module Door_Controller_tb;
reg     CLK_tb;
reg     RST_tb;
reg     Activate_tb;
reg     UP_MAX_tb;
reg     DOWN_MAX_tb;
wire    UP_M_tb;
wire    DOWN_M_tb;


//*************** initial block ***************//
initial 
 begin
   
 // system functions
 
   $dumpfile("FSM1.vcd") ;       
   $dumpvars; 
 
   initialize();
   reset();
   
 //*************** activate motor ***************//
   Activate(); 

  //*************** check motor works well or not ***************//
   check(1'b1,1'b0);

   Up_Sensor();

//*************** activate motor ***************//
   Activate(); 

 //*************** check motor works well or not ***************//
   check(1'b0,1'b1);

   Down_Sensor();

#100

  $finish ;
 
 end  
   

                  
//*************** initialization task ***************//              
                  
task initialize;
       begin
     Activate_tb = 1'b0  ;
     CLK_tb      = 1'b1    ;
     UP_MAX_tb   = 1'b0    ;
     DOWN_MAX_tb = 1'b1    ;           
                  
        end        
     endtask
//*************** Rest task ***************//          
task reset;
       begin
     RST_tb =  'b1;
     #1
     RST_tb  = 'b0;
     #1
     RST_tb  = 'b1;
       end
endtask    
//*************** Activate task ***************// 
task Activate ();
  
begin
 Activate_tb = 1'b1 ;
 #30
 Activate_tb = 1'b0 ;                   // behaviour of push button pressed then released 
end

endtask              
             
 
//*************** UP sensor ***************//
  
task Up_Sensor ();

begin 
#60                  // Time for the up motor to competely open the door
UP_MAX_tb = 1'b1 ;  
DOWN_MAX_tb = 1'b0 ;
end

endtask  

//*************** Down sensor ***************//
  
task Down_Sensor ();
  
begin 
#40                  // Time for the down motor to competely close the door
UP_MAX_tb = 1'b0 ; 
DOWN_MAX_tb = 1'b1 ;
end


endtask  

////////////////////// Check Output /////////////////////
 
task check (
  input   reg   UP_M      ,
  input   reg   DOWN_M      
);
  
begin
    if(UP_M_tb == UP_M &&  DOWN_M_tb == DOWN_M)   
     begin
      $display(" The Motor Works Well ");
     end  
    else
     begin
      $display(" The Motor is not Working Well ");
     end          
end

endtask                   
//*************** Clk generator ***************//

always #10  CLK_tb = !CLK_tb ;
  


//*************** DUT Instantation ***************//


Door_Controller DUT (
.CLK(CLK_tb),
.RST(RST_tb),
.Activate(Activate_tb),
.UP_MAX(UP_MAX_tb),
.DOWN_MAX(DOWN_MAX_tb),
.UP_M(UP_M_tb),
.DOWN_M(DOWN_M_tb)
);


endmodule                    
                  