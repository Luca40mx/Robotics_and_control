clc; clearvars; close all;

%% parameters %%
t_interval = [1 2 3 2 3 1 2 3]; % SONO INTERVALLI PER FARE I VARI TRATTI!!!!! NON SONO I TEMPI DI PASSAGGIO!
t_waypoints = cumsum([0, t_interval]);
q_points = [0 3 5 10 12 0 -2 -10 -5]; % posizioni corrispondenti
mu = 0.2;

[s, dds] = Create_Smooth_Spline(t_interval, q_points, mu)
syms t;
curva = sym([]);

for i = 1:length(t_waypoints) - 1
    first = ((s(i + 1) / (t_interval(i))) - (t_interval(i) * dds(i + 1)) / 6) * (t - t_waypoints(i));
    second = ((s(i) / (t_interval(i))) - ((t_interval(i)) * dds(i)) / 6) * (t_waypoints(i + 1) - t);
    third = (dds(i) / (6 * (t_interval(i)))) * (t_waypoints(i + 1) - t) ^ 3;
    fourth = (dds(i + 1) / 6 * (t_interval(i))) * (t - t_waypoints(i)) ^ 3;
    curva(i) = first + second + third + fourth;
end

d_curva = diff(curva, t);
dd_curva = diff(d_curva, t);

figure(1); hold on; grid on
title("Position")
fplot(curva(1), [t_waypoints(1), t_waypoints(2)]);
fplot(curva(2), [t_waypoints(2), t_waypoints(3)]);
fplot(curva(3), [t_waypoints(3), t_waypoints(4)]);
fplot(curva(4), [t_waypoints(4), t_waypoints(5)]);
fplot(curva(5), [t_waypoints(5), t_waypoints(6)]);
fplot(curva(6), [t_waypoints(6), t_waypoints(7)]);
fplot(curva(7), [t_waypoints(7), t_waypoints(8)]);
fplot(curva(8), [t_waypoints(8), t_waypoints(9)]);
scatter(t_waypoints, q_points, "x");

%% velocita'
figure(2); hold on; grid on
title("Velocity")
fplot(d_curva(1), [t_waypoints(1), t_waypoints(2)]);
fplot(d_curva(2), [t_waypoints(2), t_waypoints(3)]);
fplot(d_curva(3), [t_waypoints(3), t_waypoints(4)]);
fplot(d_curva(4), [t_waypoints(4), t_waypoints(5)]);
fplot(d_curva(5), [t_waypoints(5), t_waypoints(6)]);
fplot(d_curva(6), [t_waypoints(6), t_waypoints(7)]);
fplot(d_curva(7), [t_waypoints(7), t_waypoints(8)]);
fplot(d_curva(8), [t_waypoints(8), t_waypoints(9)]);

%% accelerazione
figure(3); hold on; grid on
title("Acceleration")
fplot(dd_curva(1), [t_waypoints(1), t_waypoints(2)]);
fplot(dd_curva(2), [t_waypoints(2), t_waypoints(3)]);
fplot(dd_curva(3), [t_waypoints(3), t_waypoints(4)]);
fplot(dd_curva(4), [t_waypoints(4), t_waypoints(5)]);
fplot(dd_curva(5), [t_waypoints(5), t_waypoints(6)]);
fplot(dd_curva(6), [t_waypoints(6), t_waypoints(7)]);
fplot(dd_curva(7), [t_waypoints(7), t_waypoints(8)]);
fplot(dd_curva(8), [t_waypoints(8), t_waypoints(9)]);

%%
function [s, dds] = Create_Smooth_Spline(T_vals, q, mu)

    % Number of segments
    N = size(T_vals, 2);

    lambda = ((1 - mu) / (6 * mu));

    T = sym('T', [N 1]);

    A = sym(zeros(N + 1, N + 1));
    C = sym(zeros(N + 1, N + 1));

    A = A + diag(T, -1);
    A = A + 2 * diag([T; 0] + [0; T]);
    A = A + diag(T, 1);

    C = C + diag(6 ./ T, -1);
    C = C + diag(-6 ./ ([T; 0] + [0; T]));
    C = C + diag(6 ./ T, 1);

    W = eye(N + 1);

    A = double(subs(A, T, T_vals'));
    C = double(subs(C, T, T_vals'));
    s = inv(W + lambda * C' * inv(A) * C) * W * q'; %#ok<*MINV>
    dds = inv(A + lambda * C' * inv(W) * C') * C * q';

end
