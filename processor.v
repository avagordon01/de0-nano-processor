module processor (
    input            CLOCK_50,
    output reg [7:0] LED,
    input      [1:0] KEY,
    input      [3:0] SW,

    output [12:0] DRAM_ADDR,
    output  [1:0] DRAM_BA,
    output        DRAM_CAS_N,
    output        DRAM_CKE,
    output        DRAM_CLK,
    output        DRAM_CS_N,
    inout  [15:0] DRAM_DQ,
    output  [1:0] DRAM_DQM,
    output        DRAM_RAS_N,
    output        DRAM_WE_N,

    output        EPCS_ASDO,
    input         EPCS_DATA0,
    output        EPCS_DCLK,
    output        EPCS_NCSO,

    output        G_SENSOR_CS_N,
    input         G_SENSOR_INT,
    output        I2C_SCLK,
    inout         I2C_SDAT,

    output        ADC_CS_N,
    output        ADC_SADDR,
    output        ADC_SCLK,
    input         ADC_SDAT,

    inout  [33:0] GPIO_0_D,
    input   [1:0] GPIO_0_IN,
    inout  [33:0] GPIO_1_D,
    input   [1:0] GPIO_1_IN,
    inout  [12:0] GPIO_2,
    input   [2:0] GPIO_2_IN
);
    /*reg [31:0] counter0;
    reg [31:0] counter1;

    always @(posedge CLOCK_50) begin
        if (KEY[0] == 0)
            counter1 <= counter1 - 2;
        else if (KEY[1] == 0)
            counter1 <= counter1 + 2;
        counter0 <= counter0 + 2;
        LED[0] = (counter0 & 255) < (((counter1 >> 18) + 32 * 0) & 255);
        LED[1] = (counter0 & 255) < (((counter1 >> 18) + 32 * 1) & 255);
        LED[2] = (counter0 & 255) < (((counter1 >> 18) + 32 * 2) & 255);
        LED[3] = (counter0 & 255) < (((counter1 >> 18) + 32 * 3) & 255);
        LED[4] = (counter0 & 255) < (((counter1 >> 18) + 32 * 4) & 255);
        LED[5] = (counter0 & 255) < (((counter1 >> 18) + 32 * 5) & 255);
        LED[6] = (counter0 & 255) < (((counter1 >> 18) + 32 * 6) & 255);
        LED[7] = (counter0 & 255) < (((counter1 >> 18) + 32 * 7) & 255);
    end*/

    reg [15:0] sram [15:0];
    reg [15:0] dram [15:0];
    reg [63:0] counter;
    reg [15:0] address;
    reg [15:0] instruction;
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;

    initial begin
        dram[0] <= 'h0110;
        dram[1] <= 'h0010;
        dram[2] <= 'hd001;
        dram[3] <= 'hd001;
        dram[4] <= 'hd001;
        dram[5] <= 'hd001;
        dram[6] <= 'hd001;
        dram[7] <= 'hd001;
        dram[8] <= 'hd001;
        dram[9] <= 'hd001;
        dram[10] <= 'hd001;
        dram[11] <= 'hd001;
        dram[12] <= 'h0f10;
        dram[13] <= 'h0f10;
    end

    always @(posedge CLOCK_50) begin
        counter <= counter + 1;
        LED = sram[0];
    end

    always @(posedge counter[23]) begin
            address <= sram[15];
            instruction <= dram[address];
            b <= sram[instruction[7:4]];
            c <= sram[instruction[3:0]];

            case (instruction[15:12])
                'h0: a <= instruction[7:4];
                'h1: a <= dram[b];
                'h2: dram[a] <= b;
                'h3: a <= b;
                'h4: a <= b + c;
                'h5: a <= b - c;
                'h6: a <= b * c;
                'h7: a <= b / c;
                'h8: a <= b % c;
                'h9: a <= ~b;
                'ha: a <= b | c;
                'hb: a <= b & c;
                'hc: a <= b ^ c;
                'hd: a <= b << c;
                'he: a <= b == c;
                'hf: a <= b < c;
            endcase

            sram[15] <= address + 1;
            sram[instruction[11:8]] <= a;
    end
endmodule
