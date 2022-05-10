% 1. Define function to navigate and gradient 
% 2. Do any necessary robot configuration/initialization and parameter
%     definition
% 3. Navigate the robot using a while loop
%   while (not_finished)
%         Find gradient direction
%         Find the angle to turn the robot to 
%         Turn the robot in that angle
%         Drive the robot lambda * magnitude of gradient
%         Check if we are at the end

% syms x y real
wheelBase = .235;
lambda = .001;

f = v
% [fx, fy] = gradient(v);
grad = -gradient(f, [x, y]);

% Start the robot at (1, -1) and facing up
position = [0; 0];
heading = [1.5; -1.5];

angularSpeed = .6;
linSpeed = .75;

% Neato Setup
pub = rospublisher('/raw_vel');
msg = rosmessage(pub);
msg.Data = [0; 0];
send(pub, msg)
pause(2)
placeNeato(position(1), position(2), heading(1), heading(2))

done = false;
pos = [0 0];
while ~done
    % round(position(1)*20)/20, round(position(2)*20)/20
    %t = (x == round(position(1)*20)/20) & (y == round(position(2)*20)/20);
    %indt = find(t)
    %g = [fx(indt); fy(indt)]
    g = double(subs(grad, [x ,y], [position(1), position(2)]));

%     Turning code
    crossProd = cross([heading; 0], [g; 0]);
    direction = sign(crossProd(3));
    angle = asin(norm(crossProd)/(norm(heading)*norm(g)));
    turnTime = double(angle)/angularSpeed;

    msg.Data = [-direction*angularSpeed*wheelBase/2,
                direction*angularSpeed*wheelBase/2];
    send(pub, msg)

    startTurn = rostic;
    while rostoc(startTurn) < turnTime
        pause(.01);
    end
    heading = g;

%     Moving Code
    distance = norm(g * lambda);
    forwardTime = distance / linSpeed;
    msg.Data = [linSpeed, linSpeed];
    send(pub, msg);
    startForward = rostic;
    while rostoc(startForward) < forwardTime
        pos = [pos; position(1) position(2)];
        pause(.01);
    end

    position = position + g * lambda;
    done = distance < .01; 
end

msg.Data = [0, 0];
send(pub, msg);
