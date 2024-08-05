clc; clearvars; close all;
%#ok<*NASGU>
axes_length = 0.5;
num_arrows = 10;
points = [0, 0, 0;
          1, 0, 0;
          2, 1, 0;
          2, 1, 2;
          2, 0, 2];

centers = [1, 1, 0;
           2, 1, 1];

%% first line
s = linspace(0, norm(points(2, :) - points(1, :), 100));
line_1 = points(1, :) + s' * (points(2, :) - points(1, :)) / (norm(points(2, :) - points(1, :)));

line_1_matrix = [line_1(:, 1), line_1(:, 2)];
velocity_direction = points(2, :) - points(1, :);
norm_velocity_direction = velocity_direction / norm(velocity_direction);
hold on;
quiver(points(1, 1), points(1, 2), norm_velocity_direction(1) * axes_length, norm_velocity_direction(2) * axes_length, ...
        'r', 'LineWidth', 2, 'MaxHeadSize', 2);


%% first circle
theta = linspace(0, -pi / 2, 100);
radius_1 = norm(points(2, :) - centers(1, :));
x1 = centers(1, 1) + radius_1 * cos(theta);
y1 = centers(1, 2) + radius_1 * sin(theta);
z1 = centers(1, 3) + zeros(size(theta));

circle_1 = [x1; y1; z1];

arrow_angles = linspace(0, -pi / 2, num_arrows);

% Draw the arrow
for i = 1:num_arrows

    angle = arrow_angles(i);
    x_pos = centers(1, 1) + radius_1 * cos(angle);
    y_pos = centers(1, 2) + radius_1 * sin(angle);

    % The velocity is perpendicular to the radius!
    tangent_direction = [-sin(angle), cos(angle)];
    % Acceleration is in the same direction of the radius
    radius_direction = [centers(1, 1) - x_pos, centers(1, 2) - y_pos];

    quiver(x_pos, y_pos, tangent_direction(1) * axes_length, tangent_direction(2) * axes_length, 'r', 'LineWidth', 2, 'MaxHeadSize', 1);
    quiver(x_pos, y_pos, radius_direction(1) * axes_length, radius_direction(2) * axes_length, "c", 'LineWidth', 2, 'MaxHeadSize', 1)
end


%% second circle
theta = linspace(0, pi, 100);

radius_2 = norm(points(3, :) - centers(2, :));
x2 = centers(2, 1) + zeros(size(theta));
y2 = centers(2, 2) + radius_2 * sin(theta);
z2 = centers(2, 3) + radius_2 * cos(theta);

circle_2 = [x2; y2; z2];
arrow_angles = linspace(0, pi, num_arrows);

% Draw the arrow
for i = 1:num_arrows
    angle = arrow_angles(i);
    x_pos = centers(2, 1) + 0;
    y_pos = centers(2, 2) + radius_2 * sin(angle);
    z_pos = centers(2, 3) + radius_2 * cos(angle);

    % The velocity is perpendicular to the radius!
    r = [0; y_pos - centers(2, 2); z_pos - centers(2, 3)];
    tangent_direction = [0, -r(3), r(2)];
    tangent_direction = tangent_direction / norm(tangent_direction);
    % Acceleration is in the same direction of the radius
    vector_radial = [0, radius_2 * sin(angle), radius_2 * cos(angle)];

    quiver3(x_pos, y_pos, z_pos, tangent_direction(1) * 2, tangent_direction(2) * axes_length, tangent_direction(3) * axes_length, ...
        'r', 'LineWidth', 2, 'MaxHeadSize', 2);
    quiver3(x_pos, y_pos, z_pos, vector_radial(1) * 2, -vector_radial(2) * axes_length, -vector_radial(3) * axes_length, ...
        'c', 'LineWidth', 2, 'MaxHeadSize', 2);
end

%% second line
s = linspace(0, norm(points(5, :) - points(4, :), 100));
line_2 = points(4, :) + s' * (points(5, :) - points(4, :)) / (norm(points(5, :) - points(4, :)));
velocity_direction = points(5, :) - points(4, :);
norm_velocity_direction = velocity_direction / norm(velocity_direction);
hold on;

% plotting
plot3(line_1(:, 1), line_1(:, 2), line_1(:, 3), "LineWidth", 3); grid on;
plot3(circle_1(1, :), circle_1(2, :), circle_1(3, :), "LineWidth", 3);
plot3(circle_2(1, :), circle_2(2, :), circle_2(3, :), "LineWidth", 3);
plot3(line_2(:, 1), line_2(:, 2), line_2(:, 3), "LineWidth", 3);

% Frame axis
quiver3(points(1, 1) - 1, points(1, 2), points(1, 3), axes_length, 0, 0, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
quiver3(points(1, 1) - 1, points(1, 2), points(1, 3), 0, axes_length, 0, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
quiver3(points(1, 1) - 1, points(1, 2), points(1, 3), 0, 0, axes_length, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
text(axes_length - 1, 0, 0, 'X', 'FontSize', 15, 'VerticalAlignment', 'baseline');
text(-1, axes_length, 0, 'Y', 'FontSize', 15, 'VerticalAlignment', 'baseline');
text(-1, 0, axes_length, 'Z', 'FontSize', 15, 'VerticalAlignment', 'baseline');

%% extra frame plot
quiver3(points(2, 1), points(2, 2), points(2, 3), axes_length, 0, 0, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
quiver3(points(2, 1), points(2, 2), points(2, 3), 0, axes_length, 0, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
quiver3(points(2, 1), points(2, 2), points(2, 3), 0, 0, axes_length, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
text(points(2, 1) + axes_length, 0, 0, 'X', 'FontSize', 15, 'VerticalAlignment', 'baseline');
text(points(2, 1), points(2, 2) + axes_length, 0, 'Y', 'FontSize', 15, 'VerticalAlignment', 'baseline');
text(points(2, 1), points(2, 2), points(2, 3) + axes_length, 'Z', 'FontSize', 15, 'VerticalAlignment', 'baseline');

quiver3(points(3, 1), points(3, 2), points(3, 3), axes_length, 0, 0, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
quiver3(points(3, 1), points(3, 2), points(3, 3), 0, axes_length, 0, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
quiver3(points(3, 1), points(3, 2), points(3, 3), 0, 0, axes_length, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
text(points(3, 1) + axes_length, points(3, 2), 0, 'X', 'FontSize', 15, 'VerticalAlignment', 'baseline');
text(points(3, 1), points(3, 2) + axes_length, 0, 'Y', 'FontSize', 15, 'VerticalAlignment', 'baseline');
text(points(3, 1), points(3, 2), points(3, 3) + axes_length, 'Z', 'FontSize', 15, 'VerticalAlignment', 'baseline');

quiver3(points(4, 1), points(4, 2), points(4, 3), axes_length, 0, 0, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
quiver3(points(4, 1), points(4, 2), points(4, 3), 0, -axes_length, 0, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
quiver3(points(4, 1), points(4, 2), points(4, 3), 0, 0, -axes_length, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
text(points(4, 1) + axes_length, points(4, 2), points(4, 3), 'X', 'FontSize', 15, 'VerticalAlignment', 'baseline');
text(points(4, 1), points(4, 2) - axes_length, points(4, 3), 'Y', 'FontSize', 15, 'VerticalAlignment', 'baseline');
text(points(4, 1), points(4, 2), points(4, 3) -axes_length, 'Z', 'FontSize', 15, 'VerticalAlignment', 'baseline');

quiver3(points(5, 1), points(5, 2), points(5, 3), axes_length, 0, 0, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
quiver3(points(5, 1), points(5, 2), points(5, 3), 0, -axes_length, 0, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
quiver3(points(5, 1), points(5, 2), points(5, 3), 0, 0, -axes_length, 'blue', 'LineWidth', 3, 'MaxHeadSize', 1);
text(points(5, 1) + axes_length, points(5, 2), points(5, 3), 'X', 'FontSize', 15, 'VerticalAlignment', 'baseline');
text(points(5, 1), points(5, 2) - axes_length, points(5, 3), 'Y', 'FontSize', 15, 'VerticalAlignment', 'baseline');
text(points(5, 1), points(5, 2), points(5, 3) -axes_length, 'Z', 'FontSize', 15, 'VerticalAlignment', 'baseline');

scatter3(centers(1, 1), centers(1, 2), centers(1, 3), "LineWidth", 10);
scatter3(centers(2, 1), centers(2, 2), centers(2, 3), "LineWidth", 10);
