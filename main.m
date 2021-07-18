%% MAIN START HEADER 
 
global Blues Yellows Balls Rules FieldInfo RefState RefCommandForTeam RefPartOfFieldLeft RP PAR Modul activeAlgorithm gameStatus  
global sp 
sp = 15;
k = 10;
R = 250;
 
if isempty(RP) 
    addpath tools RPtools MODUL 
end 

mainHeader(); 
%MAP(); 
 
if (RP.Pause)  
    return; 
end 
 
zMain_End=RP.zMain_End; 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
 
 
%% CONTROL BLOCK 

MY_ROBOT_ID = 7; % tipa define

obstacles = [RP.Blue(1); RP.Blue(2); RP.Blue(3); RP.Blue(4); RP.Blue(5); RP.Blue(6); RP.Blue(8)];
target = RP.Ball.z;
coord = RP.Blue(MY_ROBOT_ID).z;
ang = RP.Blue(MY_ROBOT_ID).ang;
out = 150;

need_obst = coll_point(coord, target, obstacles, R);
fprintf("\nneed_obst: ");
disp(need_obst);

if need_obst == 0
    res_target = target;
    rot = rotate_to_point(coord, ang, res_target, k);
else
    tangent = find_tangent(coord, obstacles(need_obst).z, R, target);
    fprintf("Tangent: ");
    disp(tangent);
    res_target = tangent;
    
    fprintf("Coord: ");
    disp(coord);
    fprintf("obst: ");
    disp(obstacles(need_obst).z);
    fprintf("Norm: %f\n", norm(coord - obstacles(need_obst).z));
    
    if norm(coord - obstacles(need_obst).z) < (R + 100)
        save_target = save_out(coord, obstacles(need_obst).z, out, R);
        res_target = find_tangent(save_target, obstacles(need_obst).z, R, target);
        fprintf("Going out");
    else
        rot = rotate_to_point(coord, ang, res_target, k);
    end
end

RP.Blue(MY_ROBOT_ID).rul = go_to_point(coord, ang, res_target, sp, rot);

%% END CONTRIL BLOCK 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%% MAIN END 
 
%Rules 
 
zMain_End = mainEnd();