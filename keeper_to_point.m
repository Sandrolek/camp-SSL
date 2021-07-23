function res_target = keeper_to_point(ball_pos, gate)
    fprintf("Going to Point\n");
    
    [coeffs, ~] = polyfit(ball_pos(:, 1), ball_pos(:, 2), 1);
    k = coeffs(1);
    b = coeffs(2);
%     p1 = ball_pos(1);
%     p2 = ball_pos(5);
%     
%     k = (p2(2) - p1(2)) / (p2(1) - p1(1));
%     b = y1 - k* x1;
    
    target = [gate(1, 1), k * gate(1, 1) + b];
    
    if target(2) > gate(1, 2)
        target(2) = gate(1, 2);
    elseif target(2) < gate(2, 2)
        target(2) = gate(2, 2);
    end
    res_target = target;
end