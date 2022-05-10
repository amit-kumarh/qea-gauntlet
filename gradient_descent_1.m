x_range = -0.25:0.05:0.25;
y_line1 = ones(1,length(x_range)) .* -0.25;
y_line2 = ones(1,length(x_range)) .* 0.25;

y_range = -0.25:0.05:0.25;
x_line1 = ones(1,length(y_range)) .* -0.25;
x_line2 = ones(1,length(x_range)) .* 0.25;

prep_wall1 = [x_range; y_line1];
prep_wall2 = [x_range; y_line2];
prep_wall3 = [x_line1; y_range];
prep_wall4 = [x_line2; y_range];
box_walls = [prep_wall1 prep_wall2 prep_wall3 prep_wall4]
box_points = [box_walls; ones(1,length(box_walls(1,:)))]

theta = 0;
global_box_points_1 = [1 0 1.41; 0 1 -2; 0 0 1] * [cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1] * box_points;
theta = pi/4
global_box_points_2 = [1 0 -0.25; 0 1 -1; 0 0 1] * [cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1] * box_points;
global_box_points_3 = [1 0 1; 0 1 -0.7; 0 0 1] * [cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1] * box_points;

[x,y] = meshgrid(-2:0.05:3, -3.5:0.05:1.5);
%syms x y

v1 = 0;
for i = 1:1:length(global_box_points_1(1,:))
    points = global_box_points_1(:,i);
    v1 = v1 - log(sqrt((x - points(1)).^2 + (y - points(2)).^2));
end

v2 = 0;
for i = 1:1:length(global_box_points_2(1,:))
    points = global_box_points_2(:,i);
    v2 = v2 - log(sqrt((x - points(1)).^2 + (y - points(2)).^2));
end

v3 = 0;
for i = 1:1:length(global_box_points_3(1,:))
    points = global_box_points_3(:,i);
    v3 = v3 - log(sqrt((x - points(1)).^2 + (y - points(2)).^2));
end

v_total = v1 + v2 + v3;

x_bob = 0.75;
y_bob = -2.5;
r_bob = 0.25;

v_bob = 0;
for theta = 0:0.01:2*pi
    a = r_bob * cos(theta) + x_bob;
    b = r_bob * sin(theta) + y_bob;
    v_bob = v_bob + log(sqrt((x - a).^2 + (y-b).^2));
end

v_total_bob = v_total + v_bob;

v_wall1 = 0;
for b = -3.37:0.01:1
    a = -1.5;
    v_wall1 = v_wall1 - log(sqrt((x-a).^2 + (y-b).^2));
end

v_wall2 = 0;
for b = -3.37:0.01:1
    a = 2.5;
    v_wall2 = v_wall2 - log(sqrt((x-a).^2 + (y-b).^2));
end

v_wall3 = 0;
for a = -1.5:0.01:2.5
    b = -3.37;
    v_wall3 = v_wall3 - log(sqrt((x-a).^2 + (y-b).^2));
end

v_wall4 = 0;
for a = -1.5:0.01:2.5
    b = 1;
    v_wall4 = v_wall4 - log(sqrt((x-a).^2 + (y-b).^2));
end

v_all_walls = v_wall1 + v_wall2 + v_wall3 + v_wall4;

v = v_total_bob + v_all_walls;
contour(x, y, v, 20, 'o', 'ShowText', 'Off')
plot3(x, y, v)