module formula_tb #(parameter WIDTH = 8);

logic clk;
logic rst_n;
logic signed [WIDTH-1:0] a, b, c, d;
logic in_valid;
logic in_ready;
logic signed [WIDTH*2+2:0] q;
logic out_valid;
logic out_ready;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 0;
    #20 rst_n = 1;
end

formula #(
    .WIDTH(WIDTH)
) dut (
    .clk(clk),
    .rst_n(rst_n),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .in_valid(in_valid),
    .in_ready(in_ready),
    .q(q),
    .out_valid(out_valid),
    .out_ready(out_ready)
);

initial begin
    $dumpfile("formula_waves.vcd");
    $dumpvars(0, formula_tb);
    $dumpvars(1, dut);
end


initial begin

    a = 0;
    b = 0;
    c = 0;
    d = 0;
    in_valid = 0;
    out_ready = 1;
    
    wait(rst_n === 1);
    
    $display("Test 1");
    for (int i = 0; i < 10; i++) begin
        in_valid = 1;
        a = $urandom_range(-128, 127);
        b = $urandom_range(-128, 127);
        c = $urandom_range(-128, 127);
        d = $urandom_range(-128, 127);
        do begin
            @(posedge clk);
        end while (in_ready !== 1);
    end
    in_valid = 0;
    
    $display("Test 2");
    repeat (5) begin
        in_valid = 1;
        a = $urandom_range(-128, 127);
        b = $urandom_range(-128, 127);
        c = $urandom_range(-128, 127);
        d = $urandom_range(-128, 127);
        @(posedge clk);
        in_valid = 0;
        repeat(2) @(posedge clk);
    end
    
    $display("Test 3");
    out_ready = 0;
    repeat(3) @(posedge clk);
    out_ready = 1;
    #100;
    $finish;

end

logic signed [WIDTH*2+2:0] a_ext;
logic signed [WIDTH*2+2:0] b_ext;
logic signed [WIDTH*2+2:0] c_ext;
logic signed [WIDTH*2+2:0] d_ext;
logic signed [WIDTH*2+2:0] expected_q;

always @(posedge clk) begin
    if (out_valid && out_ready) begin
        
        a_ext = $signed(a);
        b_ext = $signed(b);
        c_ext = $signed(c);
        d_ext = $signed(d);

        expected_q = ((a_ext - b_ext) * (1 + 3*c_ext) + 4*d_ext) >>> 1;

        if (q !== expected_q) begin
            $error("Error : Input: a=%0d, b=%0d, c=%0d, d=%0d | Expected: %0d, Got: %0d",
                   a, b, c, d, expected_q, q);
        end
    end
end

always @(posedge clk) begin
    $display("[%0t] in_valid=%b, in_ready=%b, out_valid=%b, out_ready=%b, q=%0d",
             $time, in_valid, in_ready, out_valid, out_ready, q);
end

endmodule