% Original author: GodGOD from the Matlab Answers forums
% Adapted by Eric Sund

clear;
close all;

%%% Lorenz equation parametrs %%%
s = 16;
r = 45.6;
b = 4;

%%% Lorenz equation initial values %%%
u0 = 0;
v0 = 1;
w0 = 1.05;

%%% Step size and number of iterations, respectively %%%
h = 0.001;
n = 50000;

%%% Solve the transmitter circuit for a finite time period %%%
[x1, y1, z1] = masking_helper(0, n, s, r, b, u0, v0, w0, h, 0);

%%% Add some masking to the information-baring signal %%%
t_range = linspace(0, 4*pi, n)';
message = 0.01 * sin(t_range);
masked = x1 + message;

% subplot(3,1,1);
% title("Mask Plot");
% plot(t_range, message);
% 
% subplot(3,1,2);
% title("Original Signal");
% plot(x1);
% 
% subplot(3,1,3);
% title("Masked Signal");
% plot(t_range, masked);

%%% Solve the receiver circuit for a finite time period %%%
% NOTE: the last arg is the driving function
% this can be x1, or masked
[x2, y2, z2] = masking_helper(1, n, s, r, b, u0, v0-1, w0, h, masked);
recovered = masked - x2;

%%% PLOTS (COMMENT OUT WHAT YOU DON'T NEED) %%%

%%% show transmitter and receiver circuit solutions %%%
% subplot(2,2,1);
% plot(x1, y1);
% title("Transmitter Circuit (u vs. v)");
% xlabel("u(t)");
% ylabel("v(t)");
% 
% subplot(2,2,2);
% plot(x1, z1);
% title("Transmitter Circuit (u vs. w)");
% xlabel("u(t)");
% ylabel("w(t)");
% 
% subplot(2,2,3);
% plot(x2, y2);
% title("Receiver Circuit (u vs. v)");
% xlabel("u_r(t)");
% ylabel("v_r(t)");
% 
% subplot(2,2,4);
% plot(x2, z2);
% title("Receiver Circuit (u vs. w)");
% xlabel("u_r(t)");
% ylabel("w_r(t)");

%%% show transmitter and receiver signals are in sync %%
% subplot(3,1,1);
% plot(x1, x2);
% title("Transmitter vs. Receiver Signals (u)");
% xlabel("u(t)");
% ylabel("u_r(t)");
% 
% subplot(3,1,2);
% plot(y1, y2);
% title("Transmitter vs. Receiver Signals (v)");
% xlabel("v(t)");
% ylabel("v_r(t)");
% 
% subplot(3,1,3);
% plot(z1, z2);
% title("Transmitter vs. Receiver Signals (w)");
% xlabel("w(t)");
% ylabel("w_r(t)");

%%% Mask plotting %%
plot(message, recovered);
title("Info Signal vs. Recovered Info Signal");
xlabel("m(t)");
ylabel("m^{hat}(t)");

