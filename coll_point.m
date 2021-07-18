function res = coll_point(coord, target, obstacles, R)
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
    for i = 1:size(obstacles)
        d = abs(A * obstacles(i).z(1) + B * obstacles(i).z(2) + C) / sqrt(A^2 + B^2);
        if d <= R
            fprintf("I: %f, D: %f\n", i, d);
            point = inter_lines([0, -C/B], [B, -A], [0, (A*obstacles(i).z(2) - B*obstacles(i).z(1))/A], [A, B]);
            half_chord = sqrt(R^2 - d^2);
            p1 = point + norm_vec([B, -A]) * half_chord;
            p2 = point - norm_vec([B, -A]) * half_chord;
            if (x1 < p1(1) && p1(1) < x2) || (x1 > p2(1) && p2(1) > x2)
                inters = [inters; [p1, p2]];
                obstacles_inter = [obstacles_inter; i];
            end
        end
    end
    if size(inters) > 0
        fprintf("Is obst\n");
    else
        fprintf("No obst\n");
    end
    %fprintf("Inters: ");
    %disp(inters);
    min = 2390030;
    id_min = 1;
    for i = 1:size(inters)
        fprintf("Inter is obstacle\n");
        len_vec = norm([inters(i, 1) - coord(1), inters(i, 2) - coord(2)]);
        if len_vec < min
           min = len_vec;
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