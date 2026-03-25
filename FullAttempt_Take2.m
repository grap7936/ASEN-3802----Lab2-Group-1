clear; clc; close all;

%%
inch = 0.0254;
D = 1 * inch; % [m]
A = pi * D^2 / 4; % [m^2]
x0_offset = 1.375 * inch; % 1 3/8 inches
dx = 0.5 * inch;
k_vals = struct('Aluminum',130,...
'Brass',115,...
'Steel',16.2);
dataFolder = 'ASEN3802_HeatConduction_FA25';
a = dir(fullfile(dataFolder,'*mA'));
nFiles = length(a);
volts = zeros(nFiles,1);
amps = zeros(nFiles,1);
Qdot = zeros(nFiles,1);
T0 = zeros(nFiles,1);
Hexp = zeros(nFiles,1);
Han = zeros(nFiles,1);

for i = 1:nFiles

% Read file
data = readmatrix(fullfile(a(i).folder, a(i).name));
time = data(:,1);
Temperature = data(:,2:end); % CH1–CH8
parts = strsplit(a(i).name,'_');
volts(i) = str2double(erase(parts{2},'V'));
amps(i) = str2double(erase(parts{3},'mA')) / 1000; % mA → A
Qdot(i) = volts(i) * amps(i);
n_ss = 10;
T_ss = mean(Temperature(end-n_ss:end,:),1); % average temperature values across temperature channels for use in polyfit
N = length(T_ss);
x = x0_offset + (0:N-1)*dx;
p = polyfit(x, Temperature(end,:), 1);
Hexp(i) = p(1);
T0(i) = p(2);
if contains(a(i).name,'Aluminum')
k = k_vals.Aluminum;
elseif contains(a(i).name,'Brass')
k = k_vals.Brass;
elseif contains(a(i).name,'Steel')
k = k_vals.Steel;
else
error('Material not recognized in filename.');
end
Han(i) = Qdot(i) / (k * A);
%% Plot
figure
errorbar(x, T_ss, 2*ones(size(T_ss)), 'o','LineWidth',1.2); hold on
plot(x, polyval(p,x),'LineWidth',2)
plot(x, T0(i) + Han(i)*x,'LineWidth',2)
xlabel('x [m]')
ylabel('Temperature [°C]')
title(a(i).name,'Interpreter','none')
legend('Experimental Data (±2°C)', ...
'Experimental Fit (H_{exp})', ...
'Analytical (H_{an})',...
'Location','best')
grid on
end
percent_diff = abs((Hexp - Han)./Han) * 100;
Results = table(volts, amps, Qdot, T0, Hexp, Han, percent_diff, ...
'VariableNames',{'Voltage_V','Current_A','Power_W',...
'T_0','H_exp','H_an','Percent_Diff'});
disp(Results)

%% Part 2 Task 1

%Author: Josh Bumann, Graeme Appel
%clear; clc; close all;
%filereadin
num_cases = 5; % total number of material and voltage combinations
% Create cell array of T_0 values for each material for use in later looping
% Note: must transpose all material properties internally to match parameters for tables and p_0
% values
%T_0_CA = {Aluminum_25V_240mA(1,2:9)', Aluminum_30V_290mA(1,2:9)', Brass_25V_237mA(1,2:9)', Brass_30V_285mA(1,2:9)', Steel_22V_203mA(1,2:9)'};

T_0_CA = cell(nFiles,1);

for i = 1:nFiles
    data = readmatrix(fullfile(a(i).folder, a(i).name));
    Temperature = data(:,2:end);
    T_0_CA{i} = Temperature(1,:)';
end

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
%Author: Josh Bumann
%clear; clc; close all;
%filereadin

M_exp_vec = M_exp_vec(:);
M_exp_table = table(file_string, M_exp_vec)
% Create a new figure for the table
fig_table = figure('Position',[100 100 600 200]);
% Convert table to cell array for uitable
data = table2cell(M_exp_table);
% Convert any string entries to char
for r = 1:size(data,1)
for c = 1:size(data,2)
if isstring(data{r,c})
data{r,c} = char(data{r,c});
end
end
end
% Create uitable
uitable('Data', data, ...
'ColumnName', M_exp_table.Properties.VariableNames, ...
'RowName', [], ...
'Units','normalized', ...
'Position',[0 0 1 1]);
% Save as PNG
exportgraphics(fig_table, 'M_exp_table.png', 'Resolution', 300);
% M_exp_table(i) = table(file_string(i), M_exp)

%% Part 2 Task 2 -- Model IA
lengthBar = (1.27*7 + 2.54 + 7.62) *10^-2; % [m]
x_start = 7.62*10^-2; % [m]
% Bar length vector
x = linspace(0, lengthBar, 500);
% time vector
t = linspace(0, 2000);
% Define necessary constants:
alpha = 4.819*10^-5;

% Define adjusted thermal diffusivity
alpha_adj = zeros(1,5); % Preallocate to an arbitrary value

file_string = ["Aluminum 25V 240mA", "Aluminum 30V 290mA", "Brass 25V 237mA", "Brass 30V 285mA", "Steel 22V 203mA"]';
% Model IA
figure(16)
sgtitle('Model IA Transient Temperature Response')
% Model IB
figure(17)
sgtitle('Model IB Transient Temperature Response')

%Model 2
figure(18)
sgtitle('Model 2 Transient Temperature Response')

%Model3
figure(19)
sgtitle('Model 3 Adjusted Alpha Temperature Response')

% RMSE Determination
figure(20)
sgtitle('RMSE/Error and Alpha Scaling Factor')

for i = 1:nFiles % loop through all material cases
% Define and assign alpha cases
alpha_al = (130)/(2810*960);
alpha_br = (115)/(8500*380);
alpha_st = (16.2)/(8000*500);
% Use if statement to assign alpha to each different material case
if contains(a(i).name,'Aluminum')
alpha = alpha_al;
elseif contains(a(i).name,'Brass')
alpha = alpha_br;
elseif contains(a(i).name,'Steel')
alpha = alpha_st;
end

% % Create Scale Factor for Model III 
% Scale_val_Al = 0.25 : 0.25 : 1.25;
% Scale_val_Br = 0.25 : 0.25 : 1.25;
% Scale_val_St = 0.25 : 0.25 : 1.25;
% 
% % Use if statement to assign adjusted alpha to each different material case
% 
% for P = 1:length(Scale_val_Al)
% if contains(a(i).name,'Aluminum')
% alpha_adj = Scale_val_Al(P)*alpha_al;
% elseif contains(a(i).name,'Brass')
% alpha_adj = Scale_val_Br(P)*alpha_br;
% elseif contains(a(i).name,'Steel')
% alpha_adj = Scale_val_St(P)*alpha_st;
% end


T0_Cases = T0(i); % Create y-intercept or T0 for each case to satisfy plotting dimensions
% Loop through all thermocouples for plotting

for k = 1:8 % number of thermocouple channels
% Define locations for each thermocouple
x0 = 0.034925; % [m] 1 3/8 inches converted to meters for starting x0
x_TH = x0 + (1.27*10^-2)*(k-1); % Define thermal couple locations for each channel from a reference point of x0
% reset/preallocate to zero all summation terms to reset summation for each thermo-couple case
sum_analytical = zeros(10,length(t));
sum_experimental = zeros(10,length(t));
sum_ana2 = zeros(10,length(t));

% % ** Preallocation for Model III
% sum_ana_adj = zeros(10, length(t));
L = lengthBar - x_start;


for j = 1:10 % loop for number of iterations of transient solution fourier terms/nodes
eigval_n = ((2*j - 1)*pi)/(2*L); % define eigenvalue for n cases
b_n_analytical = ((8*Han(i)*(L)*(-1)^j))/((2*j -1)^2*pi^2); % define fourier coefficients for analytical case
b_n_experimental = ((8*Hexp(i)*(L)*(-1)^j))/((2*j -1)^2*pi^2); % define fourier coefficients for experimental case

%adjusted bn for model 2
M = M_exp_vec(i);
bn_ana_2 = ((8*(abs(M-Han(i)))*(L)*(-1)^j))/((2*j -1)^2*pi^2);
%(2*(M - Han(i))/L) * (-L*cos(eigval_n*L)/eigval_n + sin(eigval_n*L)/(eigval_n^2));

% For summation terms, now we incorporate the horizontal distance for each thermal couple by
% looping through x_TH
analytical = b_n_analytical*sin(eigval_n.*x_TH).*exp(-1*alpha*eigval_n^2.*t);

% % Made with analytical value for Model III
% analytical_adj = b_n_analytical*sin(eigval_n.*x_TH).*exp(-1*alpha_adj*eigval_n^2.*t);

%mod 2
ana_2 = bn_ana_2*sin(eigval_n.*x_TH).*exp(-alpha*eigval_n^2.*t);
if j == 1
sum_ana2(1, :) = ana_2;
else
sum_ana2(j,:) = ana_2 + sum_ana2(j-1, :);
end

% % Summation for Model III
% 
% if j == 1
% 
% sum_ana_adj(1, :) = analytical_adj;
% 
% else
% 
% sum_ana_adj(j,:) = analytical_adj + sum_ana_adj(j-1, :);
% 
% end

if j == 1
sum_analytical(1, :) = analytical;
else
sum_analytical(j,:) = analytical + sum_analytical(j-1, :);
end
experimental = b_n_experimental*sin(eigval_n.*x_TH).*exp(-1*alpha*eigval_n^2.*t);
if j == 1
sum_experimental(1,:) = experimental;
else
sum_experimental(j,:) = experimental + sum_experimental(j-1,:);
end
end

% sum each row to get a lump sum value or true summation to be added to the steady state solution
sum_rows_analytical = sum_analytical(end,:);
sum_rows_experimental = sum_experimental(end,:);

%mod 2
sum_rows_ana2 = sum_ana2(end,:);

% % ** Model III lump sum value
% sum_rows_ana_adj = sum_ana_adj(end,:);

% Create y=mx+b form for plotting for analytical and experimental cases
y_analytical_SS = Han(i)*x_TH + T0_Cases;
y_experimental_SS = Hexp(i)*x_TH + T0_Cases;


% Create final solution of steady state + transient
y_analytical = sum_rows_analytical + y_analytical_SS;
y_experimental = sum_rows_experimental + y_experimental_SS;

%mod2
y_ana2_SS = T0_Cases + Hexp(i)*x_TH;
y_ana2 = sum_rows_ana2 + y_ana2_SS;

% 
% % ** Model III
% y_ana_adj_SS = T0_Cases + Hexp(i)*x_TH;
% y_ana_adj = sum_rows_ana_adj(P) + y_ana_adj_SS;
% 
% % ** Important
% % Compute Root Mean Square between experimental and adjusted analytical data set to assess visual
% % accuracy of adjusted thermal diffusivity
% 
% % Note that RMSE is given by: sqrt(mean((exoerimental - analytical_adjusted).^2))
% Accuracy_RMSE = sqrt(mean(y_experimental - y_ana_adj).^2); % Computes at every point
% Accuracy_RMSE_sum = sum(Accuracy_RMSE);
% 
% % ** Find time for each material in Model III to reach steady state i.e time index when 
% 
% 
% % ** Compute Fourier number for each state
% % F_0 = (alpha_adj*t_SS_3)/L;
% 
% % ** Display/Store both Values in a Table for Each Case


% Plot -- Model IA
figure(16)
subplot(2,3,i)
plot(t, y_analytical, "b", "LineWidth", 1.5);
hold on
plot(t, y_experimental, "r", "LineWidth", 1.5);
title(file_string(i))
xlabel("Time Elapsed [s]")
ylabel('Temperature [°C]');
legend("Analytical Thermo-couple results","Experimental Thermo-couple results", "Location","best")
% Plot -- Model IB -- using Hexp substituted in for Han for the plotted solutions
figure(17)
subplot(2,3,i)
y_analytical_IB = sum_analytical + Hexp(i)*x_TH + T0_Cases;
plot(t, y_analytical_IB, "b", "LineWidth", 1.5);
hold on
plot(t, y_experimental, "r", "LineWidth", 1.5);
title(file_string(i))
xlabel("Time Elapsed [s]")
ylabel('Temperature [°C]');
legend("Analytical Thermo-couple results","Experimental Thermo-couple results", "Location","best")
% Plot -- Model II --
figure(18)
subplot(2,3,i)
plot(t, y_ana2, "b", "LineWidth", 1.5);
hold on
plot(t, y_experimental, "r", "LineWidth", 1.5);
title(file_string(i))
xlabel("Time Elapsed [s]")
ylabel('Temperature [°C]');
legend("Analytical Thermo-couple results","Experimental Thermo-couple results", "Location","best")

% % Plot -- Model III with adjusted thermal diffusivity   FIX THIS NEXT!!!!!
% figure(19)
% subplot(2,3,i)
% plot(t, y_ana_adj, "b", "LineWidth", 1.5);
% hold on
% plot(t, y_experimental, "r", "LineWidth", 1.5);
% title(file_string(i))
% xlabel("Time Elapsed [s]")
% ylabel('Temperature [°C]');
% legend("Adjusted Analytical Thermo-couple results","Experimental Thermo-couple results", "Location","best")
% 
% % Plot RMSE between adjusted analytical model and experimental to gauge accuracy of new thermal
% % diffusivity model --> Note, the lower the RMS value point by point, the more accuracte the model is
% figure(20)
% subplot(2,3,i)
% plot(alpha_adj, Accuracy_RMSE_sum, "marker", "o");
% hold on
% title(file_string(i))
% xlabel("Time Elapsed [s]");
% ylabel('Overall lumped error');
% legend("Adjusted Analytical Thermo-couple results error", "Location","best")

end  % *******
end


%% Part 3

%% Model III -- Modifying Thermal Diffusivity to achieve more accurate model 

% Note, we want to scale thermal diffusivity, alpha, such that it stays within the range of thermal
% diffusivity ranges calculated in part 1. E.g: between 3.56*10^-5 and 4.82*10^-5

% Implement a scale factor into the original alpha assignment --> Note: this modification begins in
% line 215

% &&&&&&&&&&& To Do: Must create table for Task 1


% Make new loop for specifically model 3


% Create Scale Factor for Model III
%{
Scale_val_Al = 1;
Scale_val_Br = 1;
Scale_val_St = 1;

% Use if statement to assign adjusted alpha to each different material case
if contains(a(i).name,'Aluminum')
alpha_adj = Scale_val_Al*alpha_al;
elseif contains(a(i).name,'Brass')
alpha_adj = Scale_val_Br*alpha_br;
elseif contains(a(i).name,'Steel')
alpha_adj = Scale_val_St*alpha_st;
end

%%
% Made with analytical value for Model III
analytical_adj = b_n_analytical*sin(eigval_n.*x_TH).*exp(-1*alpha_adj*eigval_n^2.*t);

%prob need to have a analytical_adj for each each material so it gets the
%correct alpha_adj. Or have a vector of alpha_adj corresponding to each mat
%Nevermind, I think this gets taken care of by the above if statement

%%
% Summation for Model III
if j == 1
sum_ana_adj(1, :) = analytical_adj;
else
sum_ana_adj(j,:) = analytical_adj + sum_ana_adj(j-1, :);
end


% ** Model III lump sum value
sum_rows_ana_adj = sum_ana_adj(end,:);

%%
% ** Model III
y_ana_adj_SS = T0_Cases + Hexp(i)*x_TH;
y_ana_adj = sum_rows_ana_adj + y_ana_adj_SS;

%then plot
%}




%% for RMS
num_alphas = 10;
scale_val = linspace(0.8, 1.2, num_alphas);
t = linspace(0, 2000);

figure(20);
sgtitle("RMSE/Error and Determining Alpha Scaling Factor")

for i = 1:nFiles % loop through all material cases
    %scale alpha_adj
    alpha_al = (130)/(2810*960);
    alpha_br = (115)/(8500*380);
    alpha_st = (16.2)/(8000*500);

    if contains(a(i).name,'Aluminum')
    alpha = alpha_al;
    elseif contains(a(i).name,'Brass')
    alpha = alpha_br;
    elseif contains(a(i).name,'Steel')
    alpha = alpha_st;
    end

    T0_Cases = T0(i); % Create y-intercept or T0 for each case to satisfy plotting dimensions

    for B = 1:num_alphas % loop for number of alpha iterations

        alpha_adj = alpha * scale_val(B);

        for k = 1:8 % Loop for thermocouples
    
          x0 = 0.034925; % [m] 1 3/8 inches converted to meters for starting x0
          x_TH = x0 + (1.27*10^-2)*(k-1);

        L = lengthBar - x_start;

          for j = 1:10 % loop for number of iterations of transient solution fourier terms/nodes
              b_n_analytical = ((8*Han(i)*(L)*(-1)^j))/((2*j -1)^2*pi^2);
              b_n_experimental = ((8*Hexp(i)*(L)*(-1)^j))/((2*j -1)^2*pi^2); % define fourier coefficients for experimental case
              eigval_n = ((2*j - 1)*pi)/(2*L);
    
              analytical_adj = b_n_analytical*sin(eigval_n.*x_TH).*exp(-1*alpha_adj*eigval_n^2.*t);
    
                % Summation for adjusted alpha cases
                if j == 1
                sum_ana_adj(1, :) = analytical_adj;
                else
                sum_ana_adj(j,:) = analytical_adj + sum_ana_adj(j-1, :);
                end

                % Summation for Experimental Cases
                experimental = b_n_experimental*sin(eigval_n.*x_TH).*exp(-1*alpha*eigval_n^2.*t);

                if j == 1
                sum_experimental(1,:) = experimental;
                else
                sum_experimental(j,:) = experimental + sum_experimental(j-1,:);
                end
          end %end j
    
          sum_rows_ana_adj = sum_ana_adj(end,:);
          sum_rows_experimental = sum_experimental(end,:);
    
          y_ana_adj_SS = T0_Cases + Hexp(i)*x_TH;
          y_ana_adj = sum_rows_ana_adj + y_ana_adj_SS;

          y_experimental_SS = Hexp(i)*x_TH + T0_Cases;
          y_experimental = sum_rows_experimental + y_experimental_SS;

    
          Accuracy_RMSE = sqrt( mean(y_experimental - y_ana_adj).^2 ); % Computes mean (1 value) or error at every point
        
    
        end %end k

        %plot RMS vs. alpha_adj (prob not inside k loop)
        figure(20)
        subplot(2,3,i)
        plot(alpha_adj, Accuracy_RMSE, "bo"); %??? should this be the sum of Accuracy_RMSE
        hold on
        title(file_string(i))
        xlabel("Alpha Values")
        ylabel('RMSE');
        legend("Adjusted Analytical Thermo-couple results error", "Location","best")


    % Plot -- Model III with adjusted thermal diffusivity   FIX THIS NEXT!!!!!
    figure(19)
    subplot(2,3,i)
    plot(t, y_ana_adj, "b", "LineWidth", 1.5);
    hold on
    plot(t, y_experimental, "r", "LineWidth", 1.5);
    title(file_string(i))
    xlabel("Time Elapsed [s]")
    ylabel('Temperature [°C]');
    legend("Adjusted Analytical Thermo-couple results","Experimental Thermo-couple results", "Location","best")

    end %end a

end %end i

