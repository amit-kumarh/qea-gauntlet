clf; hold on
plot(pos(:,1), pos(:,2))
fcontour(v)
title('Intented Path of Gradient Descent')
xlabel('X Position (m)')
ylabel('Y Position (m)')
legend('Gradient Descent Path', 'Gauntlet Equation')
