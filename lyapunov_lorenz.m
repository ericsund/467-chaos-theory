% http://www.chebfun.org/examples/ode-nonlin/LyapunovExponents.html


dom = [0,30];

sigma = 16;
r = 45.6;
b = 4;

N = chebop(@(t,x,y,z) [ diff(x) - sigma*(y - x);
                        diff(y) - (r*x) + y + x.*z;
                        diff(z) + (b*z) - x.*y ], dom);
                    
ep = 1e-9;
N.lbc = @(x,y,z) [x+2; y+3; z-14];
[x1,y1,z1] = deal(N\0);    % Components of 1st trajectory
N.lbc = @(x,y,z) [x+2; y+3; z-14+ep];
[x2,y2,z2] = deal(N\0);    % Components of 2nd trajectory

d = sqrt(abs(x1-x2).^2 + abs(y1-y2).^2 + abs(z1-z2).^2);
semilogy(d)
xlabel('time')
title('magnitude of separation of nearby Lorenz trajectories')

logd = log(d{0, 25});
logd2 = polyfit(logd, 1);
slope = logd2(1) - logd2(0)

hold on
x = chebfun('x', [0 dom(2)]);
semilogy(.8e-9 * exp(slope*x), 'k--')
legend('dist(traj_1, traj_2)', sprintf('exp(%1.2f x)', slope), ...
    'location', 'northwest')