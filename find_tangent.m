function point = find_tangent(coord, obst, R, glob_target)
    vec = obst - coord;
    target = glob_target - coord;

    sina = R / norm(vec);
    cosa = sqrt(1 - sina^2);
    %a = asin(sina);
    %cosa = cos(a);
    %sina = sin(a);
    %fprintf("Coord:");
    %disp(coord);
    %fprintf("Obst:");
    %disp(obst);
    
    %fprintf("Norm: %f, R: %f\n", sqrt((obst(1) - coord(1))^2 + (obst(2) - coord(2))^2), R);
    if norm(vec) > R
        s = sqrt(norm(vec)^2 - R^2);
    else
        s = 1;
    end
    
    x = vec(1);
    y = vec(2);
    rot_vec_1 = [x * cosa - y * sina, x * sina + y * cosa];
    tang_vec_1 = s * rot_vec_1 / norm(rot_vec_1);
    rot_vec_2 = [x * cosa + y * sina, -x * sina + y * cosa];
    tang_vec_2 = s * rot_vec_2 / norm(rot_vec_2);
    
    % choose one tangent
    if norm(target - tang_vec_1) < norm(target - tang_vec_2)
        tang_vec = tang_vec_1;
    else
        tang_vec = tang_vec_2;
    end
    
    point = coord + tang_vec;
end