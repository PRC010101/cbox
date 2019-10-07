module codedlock (clk,rst,q,u,n,b,d,led1,led2，seg_led_1，seg_led_2);
	input wire q,u,n,b;           //四位开关作为密码输入
	input wire d;				  //一位按键作为开锁使能信号
	input wire clk;
	input wire rst;
	output wire led1;    	      //保险箱打开信号对应的led输出
	output wire led2;			//报警信号对应的led输出
	output [8:0] seg_led_1; //在小脚丫上控制一个数码管需要9个信号 
	output [8:0] seg_led_2;
	wire  [3:0]   code;	//四位变量存储密码
	wire          key_pulse;
	reg			  open;			  //保险箱开箱信号
	reg			  alarm;          //报警信号
	reg [1:0] seg [9:0];
	assign		code = {q,u,n,b};
	debounce  u1 (                               
                       .clk (clk),
                       .rst (rst),
                       .key (d),
                       .key_pulse (key_pulse)
                       );        //按键消抖
	always@(d or code)
		if(d == 1'b1)             //使能，开始判断密码
			begin
				if(code == 4'b0101)   
					begin
					open = 1'b1;  //开锁
					alarm = 1'b0; //没报警
					seg[0] = 9'h7f;
					seg[1] = 9'h06;//箱子里的东西
					end
				else
					begin
					open = 1'b0;  
					alarm = 1'b1;
					seg[0] = 9'h3f;
					seg[1] = 9'h3f;//箱子里没东西
					end
			end
		else
			begin
			open = 1'b0;
			seg[0] = 9'h3f;
			seg[1] = 9'h3f;//箱子里没东西
			end
	assign  led1 = ~open;		//led亮表示密码锁没开
	assign	led2 = ~alarm;		//led亮代表发出报警信号
	assign seg_led_1 = seg[0];
	assign seg_led_2 = seg[1];
endmodule
