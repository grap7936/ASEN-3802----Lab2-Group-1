%Part 1 Task 2
%Author: Josh Bumann

clear; clc; close all;
filereadin

time = Aluminum_25V_240mA(:,1);
T_0 = Aluminum_25V_240mA(1,2:9)';

pos =[0.0762, 0.0889, 0.1016, 0.1143, 0.1270, 0.1397, 0.1524, 0.1651]';

p_0 = polyfit(pos,T_0,1);

M_exp = p_0(1);
yInt = p_0(2);

tC = ["TC1","TC2","TC3","TC4","TC5","TC6","TC7","TC8"]';
initialSlope = table(tC, T_0, pos)
disp('M_exp')
disp(M_exp)