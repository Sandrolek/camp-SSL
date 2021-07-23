function [rul, res] = reach_obst(coord, target, rot_target, ang, obstacles, sp, accur)
    persistent is_save save_target
    if isempty(is_save)
        is_save = 0;
    end
    
    if isempty(save_target)
        save_target = [0, 0];
    end
    out = 80;
    k = 10;
    
    need_obst = coll_point(coord, target, obstacles);
    fprintf("\nneed_obst: ");
    disp(need_obst);
    
    if need_obst == 0
        % едем напрямую к цели
        res_target = target;
        fprintf("Target: ");
        disp(target);
    else
        fprintf("Coord obst: ");
        disp(obstacles(need_obst, 1:2));
        % объезжаем препятствия
        R = obstacles(need_obst, 3);
        obst = obstacles(need_obst, 1:2);
 
        tangent = find_tangent(coord, obst, R, target);
        fprintf("Tangent: ");
        disp(tangent);
        
        res_target = tangent;

        % выезд из препятствия
        fprintf("coord - obst: ");
        disp(norm(coord - obst));
        if norm(coord - obst) < R
            save_target = save_out(coord, obst, out, R);
            res_target = save_target;
            fprintf("Save_out\n");
            %is_save = 1;
%             targ_tang = find_tangent(save_target, obst, R, target);
%             if norm(target - targ_tang) < norm(target - save_target)
%                 res_target = targ_tang;
%             else
%                 res_target = save_target;
%             end
        end
    end
%     if is_save == 1
%         res_target = save_target;
%     end
    
    fprintf("Res_target: ");
    disp(res_target);
    fprintf("Save target: ");
    disp(save_target);
    
    if abs(res_target(1)) > 900
        res_target(1) = sign(res_target(1))*850;
    end
    
    [rot, ~] = rotate_to_point(coord, ang, rot_target, k);
    
    [rul, res] = go_to_point(coord, ang, res_target, sp, rot, accur);
    
    fprintf("Crul: ");
    disp(rul);
    
    fprintf("Res: ");
    disp(res);
 
%     if res == 1 && norm(res_target - save_target) == 0
%         res = 0;
%         is_save = 0;
%     end
    
    fprintf("Is_save: ");
    disp(is_save);
    
    if norm(res_target - target) ~= 0
        res = 0;
    end
end