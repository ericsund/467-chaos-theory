function [U_out,V_out,W_out] = RKmethodTransmitter(U_in,V_in,W_in,sigma,r,b,timeStep)
    u0 = U_in;
    v0 = V_in;
    w0 = W_in;

    U_k1 = eval_U(u0,v0,sigma);
    V_k1 = eval_V(u0,v0,w0,r);
    W_k1 = eval_W(u0,v0,w0,b);
    
    u0 = U_in + timeStep * U_k1 /2;
    v0 = V_in + timeStep * V_k1 /2;
    w0 = W_in + timeStep * W_k1 /2;
    
    U_k2 = eval_U(u0,v0,sigma);
    V_k2 = eval_V(u0,v0,w0,r);
    W_k2 = eval_W(u0,v0,w0,b);
    
    u0 = U_in + timeStep * U_k2 /2;
    v0 = V_in + timeStep * V_k2 /2;
    w0 = W_in + timeStep * W_k2 /2;
    
    U_k3 = eval_U(u0,v0,sigma);
    V_k3 = eval_V(u0,v0,w0,r);
    W_k3 = eval_W(u0,v0,w0,b);
    
    u0 = U_in + timeStep * U_k3;
    v0 = V_in + timeStep * V_k3;
    w0 = W_in + timeStep * W_k3;
    
    U_k4 = eval_U(u0,v0,sigma);
    V_k4 = eval_V(u0,v0,w0,r);
    W_k4 = eval_W(u0,v0,w0,b);
    
    U_out = U_in + timeStep * (U_k1 + 2 * U_k2 + 2*U_k3 + U_k4) /6;
    V_out = V_in + timeStep * (V_k1 + 2 * V_k2 + 2*V_k3 + V_k4) /6;
    W_out = W_in + timeStep * (W_k1 + 2 * W_k2 + 2*W_k3 + W_k4) /6;
end

