%% Housekeeping
clc
clear
close all


%% Apply read in file to organize and read in data

a=dir('*mA');

for i=1:length(a)
    load(a(i).name)
% how to get voltage and amperage from file names?
% - options include strsplit, regex, etc.
% ultimately, we need to use the format of each file name
% 'material'_'volts'V_'amps'mA
b = strsplit(a(i).name,'_'); % gives a cell array (b) that is 1x3
% {'material','voltsV','ampsmA'} -- now split by 'V' and 'mA'
v = strsplit(b{2},'V'); % volts are always in the second portion
ampval= strsplit(b{3},'mA'); % amps are always in the third portion
volts(i) = str2num(v{1}); % convert string to number (vector)
amps(i) = str2num(ampval{1});
end


%% Organization/Graph Set Toggling

% By setting these variables equal to 1, it turns on the graphs for a specific material and by
% setting equal to 0, the graphs are toggled off

graphs.Aluminum_25V_240mA = 0;
graphs.Aluminum_30V_290mA = 0;
graphs.Brass_25V_239mA = 0;
graphs.Brass_30V_285mA = 0;
graphs.Steel_22V_203mA = 0;
graphs.SteadyState = 0;

%% Task 1 

%% Plotting Temperature of All channels w.r.t. time for all data sets

%% Aluminum_25V_240mA Case

time.Aluminum_25V_240mA = Aluminum_25V_240mA(1,:);
Ch1.Aluminum_25V_240mA = Aluminum_25V_240mA(2,:);
Ch2.Aluminum_25V_240mA = Aluminum_25V_240mA(3,:);
Ch3.Aluminum_25V_240mA = Aluminum_25V_240mA(4,:);
Ch4.Aluminum_25V_240mA = Aluminum_25V_240mA(5,:);
Ch5.Aluminum_25V_240mA = Aluminum_25V_240mA(6,:);
Ch6.Aluminum_25V_240mA = Aluminum_25V_240mA(7,:);
Ch7.Aluminum_25V_240mA = Aluminum_25V_240mA(8,:);
Ch8.Aluminum_25V_240mA = Aluminum_25V_240mA(9,:);

% Organize into cell array for loop plotting
Channels_CA.Aluminum_25V_240mA = {time.Aluminum_25V_240mA, Ch1.Aluminum_25V_240mA, Ch2.Aluminum_25V_240mA, Ch3.Aluminum_25V_240mA, Ch4.Aluminum_25V_240mA, Ch5.Aluminum_25V_240mA, Ch6.Aluminum_25V_240mA, Ch7.Aluminum_25V_240mA, Ch8.Aluminum_25V_240mA}; % Insert structures into cell array to loop by index

% Define strings to loop through for labels
titles.Aluminum_25V_240mA = {"Aluminum 25V, 240 mA: Channel 1 temp w.r.t Time","Aluminum 25V, 240 mA: Channel 2 temp w.r.t Time", "Aluminum 25V, 240 mA: Channel 3 temp w.r.t Time", "Aluminum 25V, 240 mA: Channel 4 temp w.r.t Time", "Aluminum 25V, 240 mA: Channel 5 temp w.r.t Time", "Aluminum 25V, 240 mA: Channel 6 temp w.r.t Time", "Aluminum 25V, 240 mA: Channel 7 temp w.r.t Time", "Aluminum 25V, 240 mA: Channel 8 temp w.r.t Time" };

% Plot all Channels_CA with respect to time
if graphs.Aluminum_25V_240mA == 1

for i=1:height(Aluminum_25V_240mA)

if i >= 1 && i <= 8
figure();
plot(Channels_CA.Aluminum_25V_240mA{1},Channels_CA.Aluminum_25V_240mA{i+1},"LineWidth",1.5)
hold on
title(titles.Aluminum_25V_240mA(i));
xlabel("Time [s]")
ylabel("Temperature [ ^\circ C]")

elseif i > 8
end

end
end

%% Aluminum_30V_290mA Case

time.Al_30V_290mA = Aluminum_30V_290mA(1,:);
Ch1.Al_30V_290mA = Aluminum_30V_290mA(2,:);
Ch2.Al_30V_290mA = Aluminum_30V_290mA(3,:);
Ch3.Al_30V_290mA = Aluminum_30V_290mA(4,:);
Ch4.Al_30V_290mA = Aluminum_30V_290mA(5,:);
Ch5.Al_30V_290mA = Aluminum_30V_290mA(6,:);
Ch6.Al_30V_290mA = Aluminum_30V_290mA(7,:);
Ch7.Al_30V_290mA = Aluminum_30V_290mA(8,:);
Ch8.Al_30V_290mA = Aluminum_30V_290mA(9,:);

% Organize into cell array for loop plotting
Channels_CA.Al_30V_290mA = {time.Al_30V_290mA, Ch1.Al_30V_290mA, Ch2.Al_30V_290mA, Ch3.Al_30V_290mA, Ch4.Al_30V_290mA, Ch5.Al_30V_290mA, Ch6.Al_30V_290mA, Ch7.Al_30V_290mA, Ch8.Al_30V_290mA}; % Insert structures into cell array to loop by index

% Define strings to loop through for labels
titles.Al_30V_290mA = {"Aluminum 30V, 290 mA: Channel 1 temp w.r.t Time","Aluminum 30V, 290 mA: Channel 2 temp w.r.t Time", "Aluminum 30V, 290 mA: Channel 3 temp w.r.t Time", "Aluminum 30V, 290 mA: Channel 4 temp w.r.t Time", "Aluminum 30V, 290 mA: Channel 5 temp w.r.t Time", "Aluminum 30V, 290 mA: Channel 6 temp w.r.t Time", "Aluminum 30V, 290 mA: Channel 7 temp w.r.t Time", "Aluminum 30V, 290 mA: Channel 8 temp w.r.t Time" };

% Plot all Channels_CA with respect to time
if graphs.Aluminum_30V_290mA == 1
for i=1:height(Aluminum_30V_290mA)

if i >= 1 && i <= 8
figure();
plot(Channels_CA.Al_30V_290mA{1},Channels_CA.Al_30V_290mA{i+1},"LineWidth",1.5)
hold on
title(titles.Al_30V_290mA(i));
xlabel("Time [s]")
ylabel("Temperature [ ^\circ C]")

elseif i > 8
end

end
end

%% Brass_25V_237mA Case

time.Brass_25V_237mA = Brass_25V_237mA(1,:);
Ch1.Brass_25V_237mA = Brass_25V_237mA(2,:);
Ch2.Brass_25V_237mA = Brass_25V_237mA(3,:);
Ch3.Brass_25V_237mA = Brass_25V_237mA(4,:);
Ch4.Brass_25V_237mA = Brass_25V_237mA(5,:);
Ch5.Brass_25V_237mA = Brass_25V_237mA(6,:);
Ch6.Brass_25V_237mA = Brass_25V_237mA(7,:);
Ch7.Brass_25V_237mA = Brass_25V_237mA(8,:);
Ch8.Brass_25V_237mA = Brass_25V_237mA(9,:);

% Organize into cell array for loop plotting
Channels_CA.Brass_25V_237mA = {time.Brass_25V_237mA, Ch1.Brass_25V_237mA, Ch2.Brass_25V_237mA, Ch3.Brass_25V_237mA, Ch4.Brass_25V_237mA, Ch5.Brass_25V_237mA, Ch6.Brass_25V_237mA, Ch7.Brass_25V_237mA, Ch8.Brass_25V_237mA}; % Insert structures into cell array to loop by index

% Define strings to loop through for labels
titles.Brass_25V_237mA = {"Brass 25V, 237 mA: Channel 1 temp w.r.t Time","Brass 25V, 237 mA: Channel 2 temp w.r.t Time", "Brass 25V, 237 mA: Channel 3 temp w.r.t Time", "Brass 25V, 237 mA: Channel 4 temp w.r.t Time", "Brass 25V, 237 mA: Channel 5 temp w.r.t Time", "Brass 25V, 237 mA: Channel 6 temp w.r.t Time", "Brass 25V, 237 mA: Channel 7 temp w.r.t Time", "Brass 25V, 237 mA: Channel 8 temp w.r.t Time" };

% Plot all Channels_CA with respect to time
if graphs.Brass_25V_239mA == 1
for i=1:height(Brass_25V_237mA)

if i >= 1 && i <= 8
figure();
plot(Channels_CA.Brass_25V_237mA{1},Channels_CA.Brass_25V_237mA{i+1},"LineWidth",1.5)
hold on
title(titles.Brass_25V_237mA(i));
xlabel("Time [s]")
ylabel("Temperature [ ^\circ C]")

elseif i > 8
end

end
end

%% Brass_30V_285mA Case

time.Brass_30V_285mA = Brass_30V_285mA(1,:);
Ch1.Brass_30V_285mA = Brass_30V_285mA(2,:);
Ch2.Brass_30V_285mA = Brass_30V_285mA(3,:);
Ch3.Brass_30V_285mA = Brass_30V_285mA(4,:);
Ch4.Brass_30V_285mA = Brass_30V_285mA(5,:);
Ch5.Brass_30V_285mA = Brass_30V_285mA(6,:);
Ch6.Brass_30V_285mA = Brass_30V_285mA(7,:);
Ch7.Brass_30V_285mA = Brass_30V_285mA(8,:);
Ch8.Brass_30V_285mA = Brass_30V_285mA(9,:);

% Organize into cell array for loop plotting
Channels_CA.Brass_30V_285mA = {time.Brass_30V_285mA, Ch1.Brass_30V_285mA, Ch2.Brass_30V_285mA, Ch3.Brass_30V_285mA, Ch4.Brass_30V_285mA, Ch5.Brass_30V_285mA, Ch6.Brass_30V_285mA, Ch7.Brass_30V_285mA, Ch8.Brass_30V_285mA}; % Insert structures into cell array to loop by index

% Define strings to loop through for labels
titles.Brass_30V_285mA = {"Brass 30V, 285 mA: Channel 1 temp w.r.t Time","Brass 30V, 285 mA: Channel 2 temp w.r.t Time", "Brass 30V, 285 mA: Channel 3 temp w.r.t Time", "Brass 30V, 285 mA: Channel 4 temp w.r.t Time", "Brass 30V, 285 mA: Channel 5 temp w.r.t Time", "Brass 30V, 285 mA: Channel 6 temp w.r.t Time", "Brass 30V, 285 mA: Channel 7 temp w.r.t Time", "Brass 30V, 285 mA: Channel 8 temp w.r.t Time" };

% Plot all Channels_CA with respect to time
if graphs.Brass_30V_285mA == 1
for i=1:height(Brass_30V_285mA)

if i >= 1 && i <= 8
figure();
plot(Channels_CA.Brass_30V_285mA{1},Channels_CA.Brass_30V_285mA{i+1},"LineWidth",1.5)
hold on
title(titles.Brass_30V_285mA(i));
xlabel("Time [s]")
ylabel("Temperature [ ^\circ C]")

elseif i > 8
end

end
end

%% Steel_22V_203mA Case

time.Steel_22V_203mA = Steel_22V_203mA(1,:);
Ch1.Steel_22V_203mA = Steel_22V_203mA(2,:);
Ch2.Steel_22V_203mA = Steel_22V_203mA(3,:);
Ch3.Steel_22V_203mA = Steel_22V_203mA(4,:);
Ch4.Steel_22V_203mA = Steel_22V_203mA(5,:);
Ch5.Steel_22V_203mA = Steel_22V_203mA(6,:);
Ch6.Steel_22V_203mA = Steel_22V_203mA(7,:);
Ch7.Steel_22V_203mA = Steel_22V_203mA(8,:);
Ch8.Steel_22V_203mA = Steel_22V_203mA(9,:);

% Organize into cell array for loop plotting
Channels_CA.Steel_22V_203mA = {time.Steel_22V_203mA, Ch1.Steel_22V_203mA, Ch2.Steel_22V_203mA, Ch3.Steel_22V_203mA, Ch4.Steel_22V_203mA, Ch5.Steel_22V_203mA, Ch6.Steel_22V_203mA, Ch7.Steel_22V_203mA, Ch8.Steel_22V_203mA}; % Insert structures into cell array to loop by index

% Define strings to loop through for labels
titles.Steel_22V_203mA = {"Steel 22V, 203 mA: Channel 1 temp w.r.t Time","Steel 22V, 203 mA: Channel 2 temp w.r.t Time", "Steel 22V, 203 mA: Channel 3 temp w.r.t Time", "Steel 22V, 203 mA: Channel 4 temp w.r.t Time", "Steel 22V, 203 mA: Channel 5 temp w.r.t Time", "Steel 22V, 203 mA: Channel 6 temp w.r.t Time", "Steel 22V, 203 mA: Channel 7 temp w.r.t Time", "Steel 22V, 203 mA: Channel 8 temp w.r.t Time" };

% Plot all Channels_CA with respect to time
if graphs.Steel_22V_203mA == 1
for i=1:height(Steel_22V_203mA)

if i >= 1 && i <= 8
figure();
plot(Channels_CA.Steel_22V_203mA{1},Channels_CA.Steel_22V_203mA{i+1},"LineWidth",1.5)
hold on
title(titles.Steel_22V_203mA(i));
xlabel("Time [s]")
ylabel("Temperature [ ^\circ C]")

elseif i > 8
end

end
end


% %% Finding Steady state temperature (T @ t = final value) for each case
% num_data_sets = 5;
% 
% % To find steady state temperatures we need the latest possible times from each data set
% % t_max.Aluminum_25V_240mA = time.Aluminum_25V_240mA(end);
% % t_max.Aluminum_30V_290mA = time.Aluminum_30V_290mA(end);
% % t_max.Brass_25V_237mA = time.Brass_25V_237mA(end);
% % t_max.Brass_30V_285mA = time.Brass_30V_285mA(end);
% % t_max.Steel_22V_203mA = time.Steel_22V_203mA(end);
% % 
% % Find temperatures at max points
% % T_max.Aluminum_25V_240mA = 
% % T_max.Aluminum_30V_290mA
% % T_max.Brass_25V_237mA
% % T_max.Brass_30V_285mA
% % T_max.Steel_22V_203mA
% % 
% % 
% % 
% % Input values into cell array for plotting/looping purposes
% % t_max_CA = {t_max.Aluminum_25V_240mA, t_max.Aluminum_30V_290mA, t_max.Brass_25V_237mA, t_max.Brass_30V_285mA, t_max.Steel_22V_203mA};
% 
% % Plot Scatter Plots of overlaid data points to apply polyfit and polyval to find bestfit slopes
% if graphs.SteadyState == 1
% 
% for i = 1:num_data_sets
% 
% plot(Channels_CA.Aluminum_25V_240mA{1,end}, Channels_CA.Aluminum_25V_240mA{2,end})
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% end
% end


