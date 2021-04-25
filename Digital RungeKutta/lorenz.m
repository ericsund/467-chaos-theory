
digital = true;

sigma = 16;
r = 45.6;
b = 4;
timeStep = 0.0001;
signal_time = 20;
lorenz_time = 100;
steps = lorenz_time /timeStep;





x = linspace(0,signal_time);

input_signal = zeros(size(x));
if digital == true
    for k=1:signal_time/5
        input_signal(k) =1;
    end
    for k=2*signal_time/5:3*signal_time/5
        input_signal(k) =1;
    end
    for k=4*signal_time/5:signal_time
        input_signal(k) =1;
    end
else
    input_signal = 0.001*cos(x);
end
%input_signal = zeros(size(x));

xq = linspace(0,signal_time,steps);
M = interp1(x,input_signal,xq);
Mh = zeros(1,steps);
% disp(size(Mh));
% disp(size(M));
%%

u0 = -0.9857;
v0 = -1.3629;
w0 = 1.8208;

ur0 = u0;
vr0 = v0;
wr0 = w0;
s0 = u0;


S = zeros(1,steps);
UU = zeros(1,steps);
UUr = zeros(1,steps);
S(1) = s0;
UU(1) = u0;



% Create signal to be sent, S
for k=1:steps
    if digital == true
        if M(k) > 0.5
            b_t = b+0.4;
        else
            b_t = b;
        end
    else
        b_t = b;
    end
    [U,V,W] = RKmethodTransmitter(u0,v0,w0,sigma,r,b_t,timeStep);
    if digital == true
        S(k) = U + rand() * 0.01; %Digital
    else
        S(k) = U + M(k); % Analog
    end
    u0 = U;
    v0= V;
    w0 = W;
    UU(k) = U;
end

for k=1:steps
    if k==1
        [Ur,Vr,Wr]= RKmethodReciever(ur0,vr0,wr0,[s0,S(1)],sigma,r,b,timeStep);        
    else
        [Ur,Vr,Wr]= RKmethodReciever(ur0,vr0,wr0,S(k-1:k),sigma,r,b,timeStep);
    end
    %[Ur,Vr,Wr] = RKmethodTransmitter(ur0,vr0,wr0,sigma,r,b,timeStep);
    Mh(k) = S(k) - Ur;
    ur0 = Ur;
    vr0 = Vr;
    wr0 = Wr;
    UUr(k) = Ur;
end

output_signal = interp1(xq,Mh,x);



if digital ==true
    figure(1)
    clf;
    hold on
    plot(3*abs(output_signal(10:end)),'r');
    plot(abs(input_signal(10:end)),'b','linewidth',1.5);
    hold off
else
    figure(1)
    clf;
    hold on
    plot(output_signal(10:end),'r');
    plot(input_signal(10:end),'b','linewidth',1.5);
    hold off
end



