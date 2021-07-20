function [rul, res] = reach_obst(coord, target, ang, obstacles, sp, accur)
    out = 200;
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
        
        res_target = tangent;

        %fprintf("Coord: ");
        %disp(coord);
        %fprintf("obst: ");
        %disp(obstacles(need_obst).z);
        %fprintf("Norm: %f\n", norm(coord - obstacles(need_obst).z));

        if norm(coord - obst) < (R + 150)
            save_target = save_out(coord, obst, out, R);
            fprintf("Save_out\n");
            targ_tang = find_tangent(save_target, obst, R, target);
            if norm(target - targ_tang) < norm(target - save_target)
                res_target = targ_tang;
            else
                res_target = save_target;
            end
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