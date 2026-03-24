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
scale_val = linspace(.7, 1.2, num_alphas);
t = linspace(0, 2000);

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


    for a = 1:num_alphas

        alpha_adj = alpha * scale_val(a);

        for k = 1:8
    
          x0 = 0.034925; % [m] 1 3/8 inches converted to meters for starting x0
          x_TH = x0 + (1.27*10^-2)*(k-1);

          for j = 1:10 % loop for number of iterations of transient solution fourier terms/nodes
              b_n_analytical = ((8*Han(i)*(L)*(-1)^j))/((2*j -1)^2*pi^2);
              eigval_n = ((2*j - 1)*pi)/(2*L);
    
              analytical_adj = b_n_analytical*sin(eigval_n.*x_TH).*exp(-1*alpha_adj*eigval_n^2.*t);
    
                if j == 1
                sum_ana_adj(1, :) = analytical_adj;
                else
                sum_ana_adj(j,:) = analytical_adj + sum_ana_adj(j-1, :);
                end
          end %end j
    
          sum_rows_ana_adj = sum_ana_adj(end,:);
    
          y_ana_adj_SS = T0_Cases + Hexp(i)*x_TH;
          y_ana_adj = sum_rows_ana_adj + y_ana_adj_SS;
    
          Accuracy_RMSE = sqrt(mean(y_experimental - y_ana_adj).^2); % Computes at every point
          Accuracy_RMSE_sum = sum(Accuracy_RMSE);
    
        end %end k

        %plot RMS vs. alpha_adj (prob not inside k loop)
        figure(20)
        subplot(2,3,i)
        plot(alpha_adj, Accuracy_RMSE_sum, "b", "LineWidth", 1.5); %??? should this be the sum of Accuracy_RMSE
        hold on
        title(file_string(i))
        xlabel("Alpha Values")
        ylabel('RMSE');
        legend("Adjusted Analytical Thermo-couple results error", "Location","best")

    end %end a

end %end i


   
