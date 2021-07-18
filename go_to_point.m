function rul = go_to_point(coord, ang, target, sp, rot)  
    x = target(1);
    y = target(2);
    %x_local = (x - coord(1)) * cos(ang) - (y - coord(2)) * sin(ang); 
    %y_local = (x - coord(1)) * sin(ang) + (y - coord(2)) * cos(ang);
    vec = [x - coord(1), y - coord(2)];
    ang_vec = atan2(y - coord(2), x - coord(1));
    x_local = norm(vec) * cos(ang_vec - ang);
    y_local = norm(vec) * sin(ang_vec - ang);
    %x_local = 0;
    %y_local = 500;
    ang_local = atan2(y_local, x_local);
    
    %fprintf("X: %f, Y: %f, Ang: %f, Sp_X: %f, Sp_Y: %f\n", coord(1), coord(2), ang_local, sp * cos(ang_local), -sp * sin(ang_local));
    
    if norm([x - coord(1), y - coord(2)]) < 200  
        rul = Crul(0, 0, 0, rot, 0); 
    else
        %rul = Crul(0, 0, 0, 0, 0); 
        rul = Crul(sp * cos(ang_local), -sp * sin(ang_local), 0, rot, 0); 
    end
end