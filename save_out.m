function point = save_out(coord, obst, out, R)
    vec_start = coord - obst;
    
    vec_res = (out + R) * (vec_start / norm(vec_start));
    
    point = obst +  vec_res;
end