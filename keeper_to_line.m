function res = keeper_to_line(ball, gate)
    fprintf("Going to line\n");
    
    target = [gate(1, 1), ball(2)];
    
    if target(2) > gate(1, 2)
        target(2) = gate(1, 2);
    elseif target(2) < gate(2, 2)
        target(2) = gate(2, 2);
    end
    fprintf("Target: ");
    disp(target);
    res = target;
end