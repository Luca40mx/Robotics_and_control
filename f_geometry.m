clc; clearvars; close all;


% Define three points on the sphere
p1 = [2, 0, 0];
p2 = [0, 2, 0];
p3 = [0, 0, 2];

%% MANUAL IMPLEMENTATION OF THE SPHERE

% equation: (x-x0)^2 + (y-y0)^2 + (z-z0)^2 = r^2

A = 2 * [
         p2 - p1;
         p3 - p1
         ];
b = [
     sum(p2 .^ 2 - p1 .^ 2);
     sum(p3 .^ 2 - p1 .^ 2)
     ];

center = (A \ b)';

r = norm(p1 - center);

fprintf('Manual center: (%.2f, %.2f, %.2f)\n', center(1), center(2), center(3));
fprintf('Manual radius: %.2f\n', r);
syms x y z
eq_sphere = (x - center(1)) ^ 2 + (y - center(2)) ^ 2 + (z - center(3)) ^ 2 == r ^ 2;
disp('Sphere equation:')
disp(eq_sphere)

%%

% Compute great-circle arcs
num_points = 50;
arc1 = great_circle_arc(p1, p2, num_points);
arc2 = great_circle_arc(p2, p3, num_points);

% Concatenate arcs to form the complete trajectory
trajectory = [arc1; arc2];

% Plot the sphere
[X, Y, Z] = sphere(50);
figure;
surf(X * r + center(1), Y * r + center(2), Z * r + center(3), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
hold on;

% Plot the points
plot3(p1(1), p1(2), p1(3), 'bo', 'MarkerSize', 10, 'LineWidth', 5);
text(p1(1) + 0.2, p1(2), p1(3), "p1", "FontSize", 20);
plot3(p2(1), p2(2), p2(3), 'bo', 'MarkerSize', 10, 'LineWidth', 5);
text(p2(1) + 0.2, p2(2), p2(3), "p2", "FontSize", 20);
plot3(p3(1), p3(2), p3(3), 'bo', 'MarkerSize', 10, 'LineWidth', 5);
text(p3(1) + 0.2, p3(2), p3(3), "p3", "FontSize", 20);

% Plot the trajectory
plot3(trajectory(:, 1), trajectory(:, 2), trajectory(:, 3), 'k', 'LineWidth', 2);

% z-axis is orthogonal to the sphere
quiver3(trajectory(:, 1), trajectory(:, 2), trajectory(:, 3), ...
    trajectory(:, 1) - center(1), trajectory(:, 2) - center(2), trajectory(:, 3) - center(3), ...
    0.5, "r");
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid on;
title('Trajectory on Sphere');
hold off;

% Function to calculate great-circle points between two points on a sphere
% (La geodetica)
function arc_points = great_circle_arc(pA, pB, num_points)
    t = linspace(0, 1, num_points);
    omega = acos(dot(pA, pB) / (norm(pA) * norm(pB))); % the angle between Pa and Pb
    sin_omega = sin(omega);
    arc_points = (sin((1 - t) * omega) / sin_omega).' * pA + (sin(t * omega) / sin_omega).' * pB;
end
