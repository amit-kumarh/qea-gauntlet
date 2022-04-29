load('lidar.mat', 'r_all','theta_all')

origins = [0 0; 0 0; 1 0; 2 -2];
angles = [0 pi/2 0 pi/3];
offset = [-.084 0];

mainfig = figure;

for i = 1:size(origins,1)
    % Place in Neato frame and plot
    lframe = [cos(theta_all(:,i)).*r_all(:,i)...
        sin(theta_all(:,i)).*r_all(:,i)]';
    
    lframe(end+1,:) = 1;
    nframe = [1 0 offset(1);...
        0 1 offset(2);...
        0 0 1] * lframe;
    
    % Place into global frame
    % Undo rotation and translation
    
    theta = angles(i);
    rot = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1] * nframe;
    
    gframe = [1 0 origins(i,1);...
        0 1 origins(i,2);...
        0 0 1] * rot;
    
    figure;
    scatter(gframe(1,:), gframe(2,:));
    title(['Scan ',num2str(i)]);
    
    figure(mainfig);
    scatter(gframe(1,:), gframe(2,:));
    hold on;
    title('All Scans')
end
figure(mainfig);
    
    
    
    
