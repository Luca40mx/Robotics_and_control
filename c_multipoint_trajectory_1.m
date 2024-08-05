clc; clearvars; close all;
%#ok<*AGROW

% continuous velocity but discontinuous acceleration
waypoints = [0, 0;
             3, 5;
             9, 7;
             -15, 10;
             9, 18;
             0, 25]; % (position, time)

%% n-order polynomial interpolation

t = waypoints(:, 2); % time
x = waypoints(:, 1); % position

% Order of polynomial
n = length(t); % n-order polynomial (n = number of waypoints)

% Fit an n-order polynomial to the waypoints
p = polyfit(t, x, n);

t_fine = linspace(min(t), max(t), 1000);
x_fine = polyval(p, t_fine);

% coefficients for velocity
p_velocity = polyder(p);
v_fine = polyval(p_velocity, t_fine);

% coefficients for acceleration
p_acceleration = polyder(p_velocity);
a_fine = polyval(p_acceleration, t_fine);

% Ploting
figure(40);

% Position plot
subplot(3, 1, 1);
plot(t, x, 'ro', 'MarkerSize', 8, 'DisplayName', 'Waypoints'); % waypoints
hold on;
plot(t_fine, x_fine, 'b-', 'LineWidth', 2, 'DisplayName', sprintf('%d-order Polynomial Interpolation', n)); % interpolated curve
xlabel('Time');
ylabel('Position');
title('Position Interpolation');
legend('show', Location = 'northwest');
grid on;
hold off;

% Velocity plot
subplot(3, 1, 2);
plot(t_fine, v_fine, 'g-', 'LineWidth', 2, 'DisplayName', 'Velocity');
xlabel('Time');
ylabel('Velocity');
title('Velocity from Polynomial Interpolation');
legend('show');
grid on;

% Acceleration plot
subplot(3, 1, 3);
plot(t_fine, a_fine, 'm-', 'LineWidth', 2, 'DisplayName', 'Acceleration');
xlabel('Time');
ylabel('Acceleration');
title('Acceleration from Polynomial Interpolation');
legend('show');
grid on;

%% cubic spline interpolation with Euler approximation
velocity = [];

for i = 1:size(waypoints, 1) - 1
    velocity(i) = (waypoints(i + 1, 1) - waypoints(i, 1)) / (waypoints(i + 1, 2) - waypoints(i, 2)); %#ok<*SAGROW>
end

% this for cycle is made for the euler rule
for i = 1:size(waypoints, 1) - 2

    if sign(velocity(i)) ~= sign(velocity(i + 1))
        velocity(i) = 0;
    end

    if sign(velocity(i)) == sign(velocity(i + 1))
        velocity(i) = (velocity(i) + velocity(i + 1)) / 2;
    end

end

velocity = [0 velocity]; % for adding initial  velocity equal to zero

syms t real

n = size(waypoints, 1); % number of via points
a = sym("a", [n - 1, 4]); % number of segment

polynomials = sym(zeros(n - 1, 1));

for i = 1:n - 1
    polynomials(i) = a(i, 1) + a(i, 2) * t + a(i, 3) * t ^ 2 + a(i, 4) * t ^ 3;
end

equations = [];

for i = 1:n - 1
    pol(t) = polynomials(i);
    equations = [equations; pol(waypoints(i, 2)) == waypoints(i, 1)]; % condition for the initial position of each segment
    equations = [equations; pol(waypoints(i + 1, 2)) == waypoints(i + 1, 1)]; % condition for the final position of each segment
end

for i = 1:n - 1
    dpol(t) = diff(polynomials(i), t);
    equations = [equations; dpol(waypoints(i, 2)) == velocity(i)]; % condition for the initial velocity of each segment
    equations = [equations; dpol(waypoints(i + 1, 2)) == velocity(i + 1)]; % condition for the final velocity of each segment
end

sol = solve(equations);
sol = struct2cell(sol);
coefficients = reshape(sol, 4, n - 1)';

for i = 1:n - 1
    polynomials(i) = subs(polynomials(i), a(i, :), coefficients(i, :));
end

figure(1);

% Position
subplot(4, 1, 1); hold on; grid on

for i = 1:n - 1
    fplot(polynomials(i), [waypoints(i, 2), waypoints(i + 1, 2)], "LineWidth", 3);
    plot(waypoints(i, 2), waypoints(i, 1), "o", "LineWidth", 1, "MarkerSize", 10, "Color", "black");
    plot(waypoints(i + 1, 2), waypoints(i + 1, 1), "o", "LineWidth", 1, "MarkerSize", 10, "Color", "black");
end
xlabel("time");
ylabel("Position");
title("Position");


% Velocity
subplot(4, 1, 2); hold on; grid on
dpolynomials = [];

for i = 1:n - 1
    dpolynomials = [dpolynomials; diff(polynomials(i), t)];
    fplot(dpolynomials(i), [waypoints(i, 2), waypoints(i + 1, 2)], "LineWidth", 3)
end
xlabel("time");
ylabel("Velocity");
title("Velocity")


% Acceleration
subplot(4, 1, 3); hold on; grid on
ddpolynomials = [];

for i = 1:n - 1
    ddpolynomials = [ddpolynomials; diff(dpolynomials(i), t)];
    fplot(ddpolynomials(i), [waypoints(i, 2), waypoints(i + 1, 2)], "LineWidth", 3)
end
xlabel("time");
ylabel("Acceleration");
title("Acceleration")

% Jerk
subplot(4, 1, 4); hold on; grid on
dddpolynomials = [];

for i = 1:n - 1
    dddpolynomials = [dddpolynomials; diff(ddpolynomials(i), t)];
    fplot(dddpolynomials(i), [waypoints(i, 2), waypoints(i + 1, 2)], "LineWidth", 3)
end
xlabel("time");
ylabel("Jerk");
title("Jerk")

warning("off");
