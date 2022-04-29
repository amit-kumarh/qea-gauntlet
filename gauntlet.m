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

function position = flatlands()
wheelBase = .235;
lambda = .01;

syms x y
f = 16*exp(-x^2/2 - y^2/2 - x*y/2) + 4*exp(-(x+1.5)^2-(y+2.5)^2);
grad = gradient(f, [x, y]);

% Start the robot at (1, -1) and facing up
position = [1; -1];
heading = [0; 1];

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
while ~done
    g = double(subs(grad, [x ,y], [position(1), position(2)])) .* -1;

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
        pause(.01);
    end

    position = position + g * lambda;
    done = distance < .01; 
end

msg.Data = [0, 0];
send(pub, msg);

end

% Final position
% (0.081, -0.081)