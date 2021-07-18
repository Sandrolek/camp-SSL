function point = save_out(coord, obst, out, R)
    vec_start = [coord(1) - obst(1), coord(2) - obst(2)];
    
    vec_res = (out + R) * (vec_start / norm(vec_start));
    
    point = obst + vec_res;
    
    
end