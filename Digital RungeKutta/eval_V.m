function V_out = eval_V(u0,v0,w0,r)
    V_out = r * u0 - v0 - 20 * u0 * w0;
end