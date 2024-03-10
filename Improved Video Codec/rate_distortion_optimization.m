%%% Improved Video Codec -> Rate Distortion Optimization %%%

clear all;
clc;

%% Distortion vs Transmission Rate Curve

% transmission_rate = [32,30,40,36,32,30,28,30,29,28,23,18,18,15,14,12,13,12,11,8,6,6,5];
% distortion = [0.022809126,0.024503318,0.025350342,0.025944712,0.026409822,0.026791551,0.027131078,0.027426941,0.27690783,0.027926642,0.029669893,0.030928441,0.031992015,0.032883055,0.033748439,0.034490013,0.035140986,0.035990383,0.036590497,0.041847658,0.047279983,0.050483378,0.055686729];
% 
% % Polynomial degree
% degree = 3;  % Adjust the degree as desired
% 
% % Perform polynomial fitting
% coefficients1 = polyfit(transmission_rate, distortion , degree);
% 
% % Generate x-values for plotting
% xmin = min(transmission_rate);
% xmax = max(transmission_rate);
% num_points = 1000000;
% x_plot = linspace(xmin, xmax, num_points);
% 
% % Evaluate the fitted polynomial
% y_plot = polyval(coefficients1, x_plot);
% 
% % Plot the data points and the fitted curve
% figure;
% plot(transmission_rate, distortion , '*', x_plot, y_plot)
% 
% % Add labels and title
% xlabel('Transmission Rate (kbps)')
% ylabel('Distortion')
% title('Distortion vs. Transmission Rate')
% ylim([0.022, 0.06])
% 
% % Add legends
% legend('Data Points', '4th Order')

%% Quantization Matrix Multiplication Factor vs Transmission Rate Curve

transmission_rate = [32,30,40,36,32,30,28,30,29,28,23,18,18,15,14,12,13,12,11,8,6,6,5];
q_matrix_mf = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,2,3,4,5,6,7,8,9,10,20,30,40,50];

% Polynomial degree
degree = 4;  % Adjust the degree as desired

% Perform polynomial fitting
coefficients2 = polyfit(transmission_rate, q_matrix_mf , degree);

% Generate x-values for plotting
xmin = min(transmission_rate);
xmax = max(transmission_rate);
num_points = 1000;
x_plot = linspace(xmin, xmax, num_points);

% Evaluate the fitted polynomial
y_plot = polyval(coefficients2, x_plot);

% Plot the data points and the fitted curve
figure;
plot(transmission_rate, q_matrix_mf, '*', x_plot, y_plot)

% Add labels and title
xlabel('Transmission Rate (kbps)')
ylabel('Quantization Matrix Multiplication Factor')
title('Quantization Matrix Multiplication Factor vs. Transmission Rate')

% Add legends
legend('Data Points', '4th Order')

