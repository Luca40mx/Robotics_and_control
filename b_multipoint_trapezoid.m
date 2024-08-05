clc; clearvars; close all;


% Define waypoints and times
waypoints = [0, 3, 4, 7, 12]; % Positions of the waypoints
times = [0, 3, 4, 7, 12];      % Times at which to reach each waypoint
v_max = 1.5;                    % Maximum velocity

% Preallocate arrays for position, velocity, acceleration, and time
num_segments = length(waypoints) - 1;
positions = [];
velocities = [];
accelerations = [];
times_total = [];

for i = 1:num_segments
    % Define the start and end positions and times for the current segment
    p_start = waypoints(i);
    p_end = waypoints(i + 1);
    t_start = times(i);
    t_end = times(i + 1);
    t_segment = t_end - t_start;
    
    % Calculate times for acceleration, constant velocity, and deceleration phases
    t_acc = min(t_segment / 3, v_max * t_segment / abs(p_end - p_start));
    t_dec = t_acc;
    t_const = t_segment - t_acc - t_dec;
    
    % Time vectors for each phase
    t1 = linspace(t_start, t_start + t_acc, 100);
    t2 = linspace(t_start + t_acc, t_start + t_acc + t_const, 100);
    t3 = linspace(t_start + t_acc + t_const, t_end, 100);
    
    % Calculate the velocity profiles
    v1 = (v_max / t_acc) * (t1 - t_start);
    v2 = v_max * ones(size(t2));
    v3 = v_max - (v_max / t_dec) * (t3 - (t_start + t_acc + t_const));
    
    % Concatenate the velocity profiles
    velocities = [velocities, v1, v2, v3];
    
    % Calculate the position profiles
    p1 = p_start + 0.5 * (v_max / t_acc) * (t1 - t_start).^2;
    p2 = p1(end) + v_max * (t2 - (t_start + t_acc));
    p3 = p2(end) + v_max * (t3 - (t_start + t_acc + t_const)) - 0.5 * (v_max / t_dec) * (t3 - (t_start + t_acc + t_const)).^2;
    
    % Concatenate the position profiles
    positions = [positions, p1, p2, p3];
    
    % Calculate the acceleration profiles
    a1 = (v_max / t_acc) * ones(size(t1));
    a2 = zeros(size(t2));
    a3 = -(v_max / t_dec) * ones(size(t3));
    
    % Concatenate the acceleration profiles
    accelerations = [accelerations, a1, a2, a3];
    
    % Concatenate the time vectors
    times_total = [times_total, t1, t2, t3];
end

% Plot the position, velocity, and acceleration
figure;

subplot(3, 1, 1);
plot(times_total, positions, 'r', 'LineWidth',2); hold on
plot(waypoints, times, "o", "MarkerSize", 5, "Color", "b", "LineWidth", 2)
title('Position vs Time');
xlabel('Time (s)');
ylabel('Position (m)');
grid on

subplot(3, 1, 2);
plot(times_total, velocities, 'b', 'LineWidth',2);
title('Velocity vs Time');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
grid on

subplot(3, 1, 3);
plot(times_total, accelerations, 'g', 'LineWidth',2 );
title('Acceleration vs Time');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
grid on