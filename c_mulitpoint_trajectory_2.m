clc; clearvars; close all;

% continuous acceleration
waypoints = [0, 0;
             3, 5;
             9, 7;
             15, 10;
             9, 18;
             0, 25]; % (position, time)

% Define the velocities at the initial and final points
v_initial = 0; % initial velocity
v_final = 0; %  final velocity

% Cubic spline
pp = csape(waypoints(:, 2), waypoints(:, 1), 'clamped', [v_initial, v_final]);
pp_velocity = fnder(pp, 1);
pp_acceleration = fnder(pp, 2);
pp_jerk = fnder(pp, 3);

% Plotting
t_fine = linspace(min(waypoints(:, 2)), max(waypoints(:, 2)), 100);
y_fine = ppval(pp, t_fine);
velocity_fine = ppval(pp_velocity, t_fine);
acceleration_fine = ppval(pp_acceleration, t_fine);
jerk_fine = ppval(pp_jerk, t_fine);

figure;
subplot(4, 1, 1);
hold on;
plot(t_fine, y_fine, "LineWidth", 2); % Position
plot(waypoints(:, 2), waypoints(:, 1), 'o', 'MarkerFaceColor', 'r'); % Path points

xlabel('Time');
ylabel('Path');
title('Cubic Spline');
legend('Path Points', 'Cubic Spline');
grid on;

% Velocity
subplot(4, 1, 2);
plot(t_fine, velocity_fine, "LineWidth", 2); % Velocity
xlabel('Time');
ylabel('Velocity');
title('Velocity');
grid on;

% Acceleration
subplot(4, 1, 3);
plot(t_fine, acceleration_fine, "LineWidth", 2); % Acceleration
xlabel('Time');
ylabel('Acceleration ');
title('Acceleration (CONTINUOUS!)');
grid on;

% Jerk
subplot(4, 1, 4);
plot(t_fine, jerk_fine, "LineWidth", 2); % Jerk
xlabel('Time');
ylabel('Jerk');
title('Jerk');
grid on;
warning("off");
