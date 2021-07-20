%% MAIN START HEADER 
 
global Blues Yellows Balls Rules FieldInfo RefState RefCommandForTeam RefPartOfFieldLeft RP PAR Modul activeAlgorithm gameStatus  
global state last_rot
sp = 15;
k = 10;
R = 230;
R_BALL = 150;
 
if isempty(RP) 
    addpath tools RPtools MODUL 
end 

if isempty(state) 
    state = 0;
end 

if isempty(last_rot)
    last_rot = 0;
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

obstacles = [RP.Blue(1).z, R; RP.Blue(2).z, R; RP.Blue(3).z, R; RP.Blue(4).z, R; RP.Blue(7).z, R; RP.Blue(6).z, R; RP.Blue(8).z, R; RP.Ball.z, R_BALL];
ball = RP.Ball.z;
coord = RP.Blue(MY_ROBOT_ID).z;
ang = RP.Blue(MY_ROBOT_ID).ang;
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

switch state
    case 0 
        [RP.Blue(MY_ROBOT_ID).rul, res] = reach_obst(coord, vec, ang, obstacles, sp, accur);
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
    case 10 
        RP.Blue(5).rul = go_to_point(RP.Blue(5).z, RP.Blue(5).ang, [500, 500], sp, 0, 150);
        RP.Blue(MY_ROBOT_ID).rul = go_to_point(coord, ang, [800, 800], sp, 0, 150);
end
%% END CONTRIL BLOCK 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%% MAIN END 
 
%Rules 
 
zMain_End = mainEnd();