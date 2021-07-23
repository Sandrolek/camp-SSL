%% MAIN START HEADER 
 
global Blues Yellows Balls Rules FieldInfo RefState RefCommandForTeam RefPartOfFieldLeft RP PAR Modul activeAlgorithm gameStatus  
global state last_state last_rot ball_pos

keeper_sp = 30;
sp = 30;
Pk = 0.3;

k = 10;

R = 220;
R_BALL = 100;

gate = [[-1250, 430]; [-1250, -550]];

check_time = 0.05;
 
if isempty(RP) 
    addpath tools RPtools MODUL 
end 

if isempty(state) 
    state = 0;
end 

if isempty(last_state) 
    last_state = 0;
end 

if isempty(last_rot)
    last_rot = 0;
end

if isempty(ball_pos)
    ball_pos = [[0, 0]; 
                [0, 0]; 
                [0, 0];
                [0, 0];
                [0, 0]];
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

MY_ROBOT_ID = 6; % tipa define
KEEPER_ID = 8;

obstacles = [%RP.Blue(1).z, R; 
             %RP.Blue(2).z, R;
             RP.Blue(3).z, R;
             %RP.Blue(4).z, R;
             %RP.Blue(5).z, R;
             %RP.Blue(6).z, R;
             RP.Blue(7).z, R; 
             RP.Ball.z, R_BALL];

if RP.Ball.I
    old_ball = RP.Ball;    
else
    RP.Ball = old_ball;
end

ball = RP.Ball.z;

coord = RP.Blue(MY_ROBOT_ID).z;
ang = RP.Blue(MY_ROBOT_ID).ang;

coord_keeper = RP.Blue(KEEPER_ID).z;
ang_keeper = RP.Blue(KEEPER_ID).ang;

goal = [1500, 0];

with_dribler = 0;
now_time = 0;

x1 = ball(1);
y1 = ball(2);
x2 = goal(1);
y2 = goal(2);
A = (y2 - y1) / (x2 - x1);
B = -1;
C = y1 - x1 * A;

ball_point = 120;

vec = goal + ((ball - goal) / norm(ball - goal)) * (norm(ball - goal) + ball_point);

fprintf("Coord: ");
disp(coord);
fprintf("Ball: ");
disp(ball);
fprintf("Vec: ");
disp(vec);

accur = 10;

%%%%%%%%%%%%% НАПАДАЮЩИЙ (ATTACKER) %%%%%%%%%%%%%
rul = Crul(0, 0, 0, 0, 0);
rul.AutoKick = 2;
switch state
    case 0
        [rul, res] = reach_obst(coord, vec, goal, ang, obstacles, sp, accur);
        if res == 1
            state = 1;
        end
    case 1
        fprintf("State is 1\n");
        
        if last_state == 0
            fprintf("Got to point\n");
            with_dribler = 1;
            next_time = cputime() + 3;
            rul.EnableSpinner = true;
            rul.SpinnerSpeed = 15;
        end

        if with_dribler == 1
            fprintf("With Dribler");
            if cputime() > next_time()
                with_dribler = 0;
                rul.EnableSpinner = false;
                rul.SpinnerSpeed = 0;
            else
                [rot, ~] = rotate_to_point(coord, ang, goal, k);
                [rul, ~] = go_to_point(coord, ang, ball, 8, rot, accur);
            end
        else
            if norm(ball - coord) > 250
                state = 0;  
            end
            
            [rot, ~] = rotate_to_point(coord, ang, goal, k);
            [rul, ~] = go_to_point(coord, ang, ball, sp, rot, accur); 
            
        end
        
        %fprintf("Got to point\n");
end

RP.Blue(MY_ROBOT_ID).rul = rul;

last_state = state;
%%%%%%%%%%%% ВРАТАРЬ (GOALKEEPER) %%%%%%%%%%%%%

accur = 100;

fprintf("Ball_pos: ");
disp(ball_pos);
if cputime() > next_time
    next_time = cputime() + check_time;
    ball_pos = [ball; ball_pos(1:4, :)];
end

%%%%%%%% ИСПРАВИТЬ ДЛЯ ОБОИХ ВОРОТ!!!!!!!!
if abs(ball_pos(1, 1) - ball_pos(5, 1)) < 10
    
    res_target = keeper_to_line(ball, gate);

elseif ((ball_pos(1, 1) - ball_pos(5, 1)) < 0 && gate(1, 1) < 0) || ((ball_pos(1, 1) - ball_pos(5, 1)) > 0 && gate(1, 1) > 0)

    res_target = keeper_to_point(ball_pos, gate);

else % если мяч движется, рассчитать его траекторию и передвинуться
    
    res_target = keeper_to_line(ball, gate);

end

rot = rotate_to_point(coord_keeper, ang_keeper, [coord_keeper(1), 1000], k);
RP.Blue(KEEPER_ID).rul = go_to_point_P(coord_keeper, ang_keeper, res_target, keeper_sp, Pk, rot, accur);

%% END CONTROL BLOCK 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%% MAIN END %%%%%%%%%%
 
%Rules 
 
zMain_End = mainEnd();