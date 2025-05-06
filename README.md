# impulse
repository for Yadro Impulse test task

Описание способов защиты от переполнения : 

 1) Введение флага переполнения . Флаг переполнения некий сигнал который равен лог 1 если достигнуто переполнение и равен лог 0 в иных случаях
 2) Увеличение разрядности . При заблаговременном увеличении разрядности ( например +1 бит или же WIDTH*2 + 2 как использовалось в реализации модуля formula ) результата переполнение становится невозможным тк как раз на случай переполнения есть свободные разряды
 3) Фиксация результата . При переполнении возвращать максимально возможный или м инимально возможный результат .
 4) Ограничение входных данных . Ограничить вводимые данные , так что-бы переполнение не возникало.

Оценка аппоратного ресурса по результатам синтеза ( САПР Vivado ) :

Report Cell Usage: 
+------+-----+------+
|      |Cell |Count |
+------+-----+------+
|1     |BUFG |     1|
|2     |LUT2 |     1|
|3     |LUT3 |     1|
|4     |LUT4 |     2|
|5     |FDRE |     4|
|6     |IBUF |     4|
|7     |OBUF |    21|
+------+-----+------+

Report Instance Areas: 
+------+---------+-------+------+
|      |Instance |Module |Cells |
+------+---------+-------+------+
|1     |top      |       |    34|
+------+---------+-------+------+

Оценка частоты по результатм синтеза ( САПР Vivado ) :

результаты  STA :

![image](https://github.com/user-attachments/assets/e968f3c9-74cf-4401-99e2-d18452b7897b)

Оценка частоты :

![image](https://github.com/user-attachments/assets/a28e092b-92d4-4e1c-9334-8e387962adf9)

Ограничения для синтезатора :

create_clock -period 1.787 -name clk -waveform {0.000 0.500} [get_ports clk]

create_generated_clock -name clk_div2 -source [get_pins mmcm/CLKIN] -divide_by 2 [get_pins mmcm/CLKOUT0]

set_clock_groups -asynchronous -group clk -group clk_div2

set_input_delay  -clock clk -max 0.1 [get_ports {data_in}] 
set_output_delay -clock clk -max 0.1 [get_ports {data_out

set_false_path -from [get_clocks clk] -to [get_clocks clk_div2]
