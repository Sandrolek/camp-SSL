function res_target = keeper_to_point(ball_pos, gate)
    fprintf("Going to Point\n");
    
    [coeffs, ~] = polyfit(ball_pos(:, 1), ball_pos(:, 2), 1);
    fprintf("Coeffs: ");
    disp(coeffs);
    k = coeffs(1);
    b = coeffs(2);
    
    target = [gate(1, 1), k * gate(1, 1) + b];
    
    if target(2) > gate(1, 2)
        target(2) = gate(1, 2);
    elseif target(2) < gate(2, 2)
        target(2) = gate(2, 2);
    end
    res_target = target;
end