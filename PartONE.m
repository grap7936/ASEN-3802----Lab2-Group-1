clear; clc; close all;
%%
saveFolder = 'Saved_Plots';
if ~exist(saveFolder,'dir')
    mkdir(saveFolder)
end

inch = 0.0254;
D = 1 * inch;                    %  [m]
A = pi * D^2 / 4;                %  [m^2]

x0_offset = 1.375 * inch;        % 1 3/8 inches
dx = .0127;  

k_vals = struct('Aluminum',130,...
                'Brass',115,...
                'Steel',16.2);

dataFolder = 'ASEN3802_HeatConduction_FA25';
a = dir(fullfile(dataFolder,'*mA'));

n = length(a);

volts = zeros(n,1);
amps  = zeros(n,1);
Q  = zeros(n,1);
T0    = zeros(n,1);
Hexp  = zeros(n,1);
Han   = zeros(n,1);

for i = 1:n

    % Read file 
    data = readmatrix(fullfile(a(i).folder, a(i).name));

    time = data(:,1);
    Temperature = data(:,2:9);   % CH1–CH8

    parts = strsplit(a(i).name,'_');

    volts(i) = str2double(erase(parts{2},'V'));
    amps(i)  = str2double(erase(parts{3},'mA')) / 1000; % mA → A

    Q(i) = volts(i) * amps(i);

    n_ss = round(0.2 * length(time));
    T_ss = mean(Temperature(end-n_ss:end,:),1);

    N = length(T_ss);
    x = x0_offset + (0:N-1)*dx;
    p = polyfit(x, Temperature(end,:), 1);

    Hexp(i) = p(1);
    T0(i)   = p(2);

    if contains(a(i).name,'Aluminum')
        k = k_vals.Aluminum;
    elseif contains(a(i).name,'Brass')
        k = k_vals.Brass;
    elseif contains(a(i).name,'Steel')
        k = k_vals.Steel;
    end

    Han(i) = Q(i) / (k * A);

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

Results = table(volts, amps, Q, T0, Hexp, Han, percent_diff, ...
    'VariableNames',{'Voltage_V','Current_A','Power_W',...
                     'T_0','H_exp','H_an','Percent_Diff'});

disp(Results)

% Clean filename (remove extension if needed)
[~, baseName, ~] = fileparts(a(i).name);

% Full path for PDF
pdfName = fullfile(saveFolder, [baseName '.pdf']);

% Save as high-quality PDF
exportgraphics(gcf, pdfName, 'ContentType','vector');