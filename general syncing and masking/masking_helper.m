function [x,y,z] = plot_helper(mode, n,s,r,b,x0,y0,z0,h, orig)
% Adapted from Alexandros Leontitsis's original script!
% Eric Sund; esund@sfu.ca

%Syntax: [x,y,z] = plot_helper(mode, n,s,r,b,x0,y0,z0,h, orig)
%_________________________________________________
%
% Simulation of the Lorentz ODE.
%    dx/dt=s*(y-x)
%    dy/dt=r*x-y-xz
%    dz/dt=x*y-b*z;
%
% x, y, and z are the simulated time series.
% n is the number of the simulated points.
% level is the noise standard deviation divided by the standard deviation of the
%   noise-free time series. We assume Gaussian noise with zero mean.
% s, r, b, and s are the parameters
% x0 is the initial value for x.
% y0 is the initial value for y.
% z0 is the initial value for z.
% h is the step size.
%
% mode: 0 for transmitter circuit; 1 for receiver circuit
% orig: feeds in the original 
%
% Notes:
% The time is n*h.
% The integration is obtained by the Euler's method.e
%
%
% Reference:
%
% Lorentz E N (1963): Deterministic nonperiodic flow. Journal of the
% Atmosphairic Sciences 20: 130-141
%
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% 45110 - Dourouti
% Ioannina
% Greece
% 
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% 16 Nov 2001

% Use iterative Euler's Method to find solutions
if mode == 0
    % Initialize transmitter
    y(1, :)=[x0 y0 z0];
    
    for i = 2:n
        ydot(1) = s*(y(i-1,2) - y(i-1,1));
        ydot(2) = r*y(i-1,1) - y(i-1,2) - y(i-1,1)*y(i-1,3);
        ydot(3) = y(i-1,1)*y(i-1,2) - b*y(i-1,3);
        y(i, :) = y(i-1,:) + h*ydot;
    end
else
    % Initialize receiver
    y(1, :)=[x0 y0 z0];
    masked = [orig];

    for i = 2:n
        ydot(1) = s*(y(i-1,2) - y(i-1,1));
        ydot(2) = r*masked(i-1,1) - y(i-1,2) - masked(i-1,1)*y(i-1,3);
        ydot(3) = masked(i-1,1)*y(i-1,2) - b*y(i-1,3);
        y(i, :) = y(i-1,:) + h*ydot;
    end
end

% Separate the solutions
x = y(:, 1);
z = y(:, 3);
y = y(:, 2);
