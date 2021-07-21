%% MAIN START HEADER 
 
global Blues Yellows Balls Rules FieldInfo RefState RefCommandForTeam RefPartOfFieldLeft RP PAR Modul activeAlgorithm gameStatus  
global state last_rot ball_pos

keeper_sp = 10;
sp = 10;
Pk = 0.006;

k = 10;

R = 230;
R_BALL = 150;

gate = [[1250, 430]; [1250, -550]];

check_time = 0.1;
 
if isempty(RP) 
    addpath tools RPtools MODUL 
end 

if isempty(state) 
    state = 0;
end 

if isempty(last_rot)
    last_rot = 0;
end

if isempty(ball_pos)
    ball_pos = [[0, 0]; [0, 0]; [0, 0]];
    next_time = cputime() + check_time;
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
 
% проверка наличия препятствия на пути удара - если есть препятствие, то
% ехать с объездом препятствий в центр ворот.
% Потом придумать, что делать с вратарем
 
%% CONTROL BLOCK 

MY_ROBOT_ID = 5; % tipa define
KEEPER_ID = 8;

obstacles = [RP.Blue(1).z, R; RP.Blue(2).z, R; RP.Blue(3).z, R; RP.Blue(4).z, R; RP.Blue(6).z, R; RP.Blue(7).z, R; RP.Blue(8).z, R; RP.Ball.z, R_BALL];

ball = RP.Ball.z;

coord = RP.Blue(MY_ROBOT_ID).z;
ang = RP.Blue(MY_ROBOT_ID).ang;

coord_keeper = RP.Blue(KEEPER_ID).z;
ang_keeper = RP.Blue(KEEPER_ID).ang;

goal = [-1500, 0];

with_dribler = 0;
now_time = 0;

x1 = ball(1);
y1 = ball(2);
x2 = goal(1);
y2 = goal(2);
A = (y2 - y1) / (x2 - x1);
B = -1;
C = y1 - x1 * A;

vec = ball - 200 * ([B, -A] / norm([B, -A]));
fprintf("Coord: ");
disp(coord);
fprintf("Ball: ");
disp(ball);
fprintf("Vec: ");
disp(vec);

accur = 50;

%%%%%%%%%%%%% НАПАДАЮЩИЙ (ATTACKER) %%%%%%%%%%%%%

switch state
    case 0 
        [RP.Blue(MY_ROBOT_ID).rul, res] = reach_obst(coord, vec, ang, obstacles, 10, Pk, accur);
        %fprintf("Res: %d\n", res);
        if res == 1
            state = 1;
        end
    case 1
        [rot, rotated] = rotate_to_point(coord, ang, goal, 10);
        if norm(ball - coord) > 250
            state = 0;
        end
        if rotated
            if last_rot == 0
                with_dribler = 1;
                next_time = cputime() + 2;
                RP.Blue(MY_ROBOT_ID).rul.EnableSpinner = true;
                RP.Blue(MY_ROBOT_ID).rul.SpinnerSpeed = 15;
            end
            fprintf("Rotated");
            
            if with_dribler == 1
                if cputime() > next_time()
                    with_dribler = 0;
                    RP.Blue(MY_ROBOT_ID).rul.EnableSpinner = false;
                    RP.Blue(MY_ROBOT_ID).rul.SpinnerSpeed = 0;
                else
                RP.Blue(MY_ROBOT_ID).rul = Crul(12, 0, 0, 0, 0);   
                end
            else
                RP.Blue(MY_ROBOT_ID).rul = Crul(12, 0, 0, 0, 0);
                if norm(ball - coord) < 150
                    fprintf("pinayu\n");
                    RP.Blue(MY_ROBOT_ID).rul = Crul(12, 0, 0, 0, 1);
                end
            end
        else
            fprintf("Not rotated");
            RP.Blue(MY_ROBOT_ID).rul = Crul(0, 0, 0, rot, 0);
        end
        last_rot = rotated;
        %fprintf("Got to point\n");
end

%%%%%%%%%%%%% ВРАТАРЬ (GOALKEEPER) %%%%%%%%%%%%%

accur = 100;

if cputime() > next_time
    next_time = cputime() + check_time;
    ball_pos(3, :) = ball_pos(2, :);
    ball_pos(2, :) = ball_pos(1, :);
    ball_pos(1, :) = ball;
end

if ball_pos(1, 1) > ball_pos(2, 1) && ball_pos(2, 1) > ball_pos(3, 1)
    res_target = keeper_to_point(ball_pos, gate);
else % если мяч движется, рассчитать его траекторию и передвинуться
    res_target = keeper_to_line(ball, gate);
   
end

% типа удар по мячу
if norm(ball - coord_keeper) < 10
    RP.Blue(KEEPER_ID).rul.AutoKick = 2;
else
    RP.Blue(KEEPER_ID).rul.AutoKick = 0;
end

%res_target = [0, 0];
%rot = rotate_to_point(coord_keeper, ang_keeper, [0, coord_keeper(2)], k);
%RP.Blue(KEEPER_ID).rul = go_to_point(coord_keeper, ang_keeper, res_target, keeper_sp, Pk, rot, accur);

%% END CONTROL BLOCK 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%% MAIN END 
 
%Rules 
 
zMain_End = mainEnd();