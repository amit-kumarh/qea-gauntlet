hold on
contour(x,y,v,'k','ShowText','On')
axis equal

raw = readmatrix('encoders.csv');
t = raw(:, 1);
L = raw(:, 2) - 14.8682;
R = raw(:, 3) - 63.9637;

rot = [cos(2*pi/3) sin(2*pi/3); -sin(2*pi/3) cos(2*pi/3)];

points = [L R]';
rpoints = rot * points;

plot(rpoints(1,:), rpoints(2,:))

title('Actual Path from Encoder Data')
xlabel('X Position (m)')
ylabel('Y Position (m)')