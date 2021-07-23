function res = coll_point(coord, target, obstacles)
    % line coord-target
    x1 = coord(1);
    y1 = coord(2);
    x2 = target(1);
    y2 = target(2);
    A = (y2 - y1) / (x2 - x1);
    B = -1;
    C = y1 - x1 * A;
    
    inters = [];
    obstacles_inter = [];
    %fprintf("Obstacles: ");
    %disp(obstacles);
    len_min = 2390030;
    id_min = 0;
    sz = size(obstacles);
    for i = 1:sz(1)
        d = abs(A * obstacles(i, 1) + B * obstacles(i, 2) + C) / sqrt(A^2 + B^2);
        if d <= obstacles(i, 3)
            %fprintf("I: %f, D: %f\n", i, d);
            point = inter_lines(coord, [B, -A], obstacles(i, 1:2), [A, B]);
            half_chord = sqrt(obstacles(i, 3)^2 - d^2);
            p1 = point + norm_vec([B, -A]) * half_chord;
            p2 = point - norm_vec([B, -A]) * half_chord;
            if (x1 < p1(1) && p1(1) < x2) || (x1 > p1(1) && p1(1) > x2)
                len = norm(p1 - coord);
                if len < len_min
                    len_min = len;
                    id_min = i;
                end
            end
            if (x1 < p2(1) && p2(1) < x2) || (x1 > p2(1) && p2(1) > x2)
                len = norm(p2 - coord);
                if len < len_min
                    len_min = len;
                    id_min = i;
                end
            end
        end
    end
    
    if id_min == 0
        res = 0;
    else
        res = id_min;
    end
    
end