%Author: Josh Bumann

clear; clc; close all;
filereadin

num_cases = 5; % total number of material and voltage combinations


% Create cell array of T_0 values for each material for use in later looping
% Note: must transpose all material properties internally to match parameters for tables and p_0
% values
T_0_CA = {Aluminum_25V_240mA(1,2:9)', Aluminum_30V_290mA(1,2:9)', Brass_25V_237mA(1,2:9)',  Brass_30V_285mA(1,2:9)', Steel_22V_203mA(1,2:9)'};
pos = [0.0762, 0.0889, 0.1016, 0.1143, 0.1270, 0.1397, 0.1524, 0.1651]'; % position of initial channels, in [m], stays uniform regardless of material or voltage

file_string = ["Aluminum 25V 240mA", "Aluminum 30V 290mA", "Brass 25V 237mA", "Brass 30V 285mA", "Steel 22V 203mA"]';
figure();

for i = 1:num_cases

p_0 = polyfit(pos,T_0_CA{i},1);


M_exp = p_0(1);
yInt = p_0(2);
Best_fit = polyval(p_0, pos);

tC = ["TC1","TC2","TC3","TC4","TC5","TC6","TC7","TC8"]';
initialSlope = table(tC, T_0_CA{i}, pos);
% disp('M_exp');
% disp(M_exp);

M_exp_vec(i) = M_exp';


% Plot temperature values overlaid with their lines of best fit
subplot(2,3,i)
plot(pos, T_0_CA{i}, "o")
hold on
plot(pos, Best_fit)

xlabel("Horizontal Position [m]")
ylabel('Temperature [°C]');
title(file_string(i));
legend("Channel Temperatures @ t = 0", "Best Fit", "Location","best")
hold off

end

M_exp_vec = M_exp_vec';
M_exp_table = table(file_string, M_exp_vec)




% M_exp_table(i) = table(file_string(i), M_exp)