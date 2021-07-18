function F = inter_lines(A, v, B, u)
    t = - vect_mul((A - B), u) / vect_mul(v, u);
    
    F = A + v * t;
end