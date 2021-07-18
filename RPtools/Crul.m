% rul = Crul(SpeedY, SpeedX, KickForward, SpeedR, KickUp) -- simple control
% rul = Crul(SpeedY, SpeedX, KickForward, SpeedR, KickUp, AutoKick, KickVoltage,
% EnableSpinner, SpinnerSpeed, KickerCharge, Beep) -- advanced control
% rul = Crul(SpeedY, SpeedX, KickForward, SpeedR, KickUp, AutoKick) --
% control with AutoKick
% rul = Crul(SpeedY, SpeedX, KickForward, SpeedR, KickUp, AutoKick, KickVoltage) --
% control with voltage
% rul = Crul(SpeedY, SpeedX, KickForward, SpeedR, KickUp, AutoKick, KickVoltage,
% EnableSpinner, SpinnerSpeed) -- control with spiner
% Function place control signals to special structure ready for copying
% to robot structure.
% RP.Blue[N].rul = rul
function rul = Crul(SpeedX, SpeedY, KickForward, SpeedR, KickUp, AutoKick, KickVoltage, EnableSpinner, SpinnerSpeed, KickerCharge, Beep)

% defSpeedX = 0;
% defSpeedY = 0;
% defKickForward = 0;
% defSpeedR = 0;
% defKickUP = 0;
defAutoKick = 0;
defKickVoltage = 12;
defEnableSpinner = 0;
defSpinnerSpeed = 0;
defKickerCharge = 1;
defBeep = 0;

if (nargin == 5)
    AutoKick = defAutoKick;
    KickVoltage = defKickVoltage;
    EnableSpinner = defEnableSpinner;
    SpinnerSpeed = defSpinnerSpeed;
    KickerCharge = defKickerCharge;
    Beep = defBeep;
end

if (nargin == 6)
    KickVoltage = defKickVoltage;
    EnableSpinner = defEnableSpinner;
    SpinnerSpeed = defSpinnerSpeed;
    KickerCharge = defKickerCharge;
    Beep = defBeep;
end

if (nargin == 7)
    EnableSpinner = defEnableSpinner;
    SpinnerSpeed = defSpinnerSpeed;
    KickerCharge = defKickerCharge;
    Beep = defBeep;
end

if (nargin == 9)
    KickerCharge = defKickerCharge;
    Beep = defBeep;
end

if ~isnumeric([SpeedY, SpeedX, KickForward, SpeedR, KickUp, AutoKick, KickVoltage, EnableSpinner, SpinnerSpeed, KickerCharge, Beep])
    warning('Crul : Not numeric input');
end
if sum(isnan([SpeedY, SpeedX, KickForward, SpeedR, KickUp, AutoKick, KickVoltage, EnableSpinner, SpinnerSpeed, KickerCharge, Beep])>0)
    warning('Crul : some element is NaN');
end
if sum(isinf([SpeedY, SpeedX, KickForward, SpeedR, KickUp, AutoKick, KickVoltage, EnableSpinner, SpinnerSpeed, KickerCharge, Beep])>0)
    warning('Crul : some element is inf');
end
rul = struct();
rul.SpeedR = SpeedR;
rul.KickUp = KickUp;
rul.KickVoltage = KickVoltage;
rul.EnableSpinner = EnableSpinner;
rul.SpinnerSpeed = SpinnerSpeed;
rul.KickerCharge = KickerCharge;
rul.AutoKick = AutoKick;
rul.Beep = Beep;
rul.SpeedY = SpeedY;
rul.SpeedX = SpeedX;
rul.KickForward = KickForward;
end

