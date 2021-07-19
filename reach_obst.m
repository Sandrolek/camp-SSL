function [rul, res] = reach_obst(coord, target, ang, obstacles, sp, accur)
    out = 150;
    k = 10;
    rot = 0;
    
    need_obst = coll_point(coord, target, obstacles);
    fprintf("\nneed_obst: ");
    disp(need_obst);
    
    if need_obst == 0
        res_target = target;
        [rot, ~] = rotate_to_point(coord, ang, res_target, k);
    else
        R = obstacles(need_obst, 3);
        obst = obstacles(need_obst, 1:2);
        
        tangent = find_tangent(coord, obst, R, target);
        fprintf("Tangent: ");
        disp(tangent);
        res_target = tangent;

        %fprintf("Coord: ");
        %disp(coord);
        %fprintf("obst: ");
        %disp(obstacles(need_obst).z);
        %fprintf("Norm: %f\n", norm(coord - obstacles(need_obst).z));

        if norm(coord - obst) < (R + 100)
            save_target = save_out(coord, obst, out, R);
            res_target = find_tangent(save_target, obst, R, target);
            %fprintf("Going out");
        else
            [rot, ~] = rotate_to_point(coord, ang, res_target, k);
        end
    end

    [rul, res] = go_to_point(coord, ang, res_target, sp, rot, accur);
        
    if res_target ~= target
        res = 0;
    end
end