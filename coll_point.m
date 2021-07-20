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
    sz = size(obstacles);
    for i = 1:sz(1)
        d = abs(A * obstacles(i, 1) + B * obstacles(i, 2) + C) / sqrt(A^2 + B^2);
        if d <= obstacles(i, 3)
            %fprintf("I: %f, D: %f\n", i, d);
            point = inter_lines([0, -C/B], [B, -A], [0, (A*obstacles(i, 1) - B*obstacles(i, 1))/A], [A, B]);
            half_chord = sqrt(obstacles(i, 3)^2 - d^2);
            p1 = point + norm_vec([B, -A]) * half_chord;
            p2 = point - norm_vec([B, -A]) * half_chord;
            if (x1 < p1(1) && p1(1) < x2) || (x1 > p2(1) && p2(1) > x2)
                inters = [inters; [p1, p2]];
                obstacles_inter = [obstacles_inter; i];
            end
        end
    end
    if size(inters) > 0
        %fprintf("Is obst\n");
    else
        %fprintf("No obst\n");
    end
    %fprintf("Inters: ");
    %disp(inters);
    len_min = 2390030;
    id_min = 1;
    sz = size(inters);
    for i = 1:sz(1)
        %fprintf("Inter is obstacle\n");
        len_vec = min([norm(inters(i, 1:2) - coord), norm(inters(i, 3:4) - coord)]);
        if len_vec < len_min
           len_min = len_vec;
           id_min = obstacles_inter(i);
        end
    end
    if size(inters) == 0
        %res = target;
        res = 0;
    else
        %fprintf("Min: %f,", id_min);%Inters[id]: %f\n", min, inters(id_min));
        res = id_min;
    end
end