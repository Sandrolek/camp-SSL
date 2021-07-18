function rot = rotate_to_point(coord, ang, target, k)
    x = target(1);
    y = target(2);
    u = [cos(ang), sin(ang)];
    v = [x - coord(1), y - coord(2)];

    ang_target = atan2(vect_mul(u, v), dot(u, v));
    
    %ang_diff = arccos((vec_robo(1) * vec_target(1) + vec_robo(2) * vec_target(2)));
    
    rot = ang_target * k;
    
    %rul = Crul(0,0,0,0,0);
    
    fprintf("Ang: %f, Ang_target: %f", ang, ang_target);
end