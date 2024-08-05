clc; clear; close all;

%% initial constrain %%

qi = 0;
qf = 20;
ti = 0;
tf = 10;
t_acc = 4; % if you put here 5 the constant velocity phase disapperar!
t_dec = 4;

syms ac0 ac1 ac2 co0 co1 de0 de1 de2 real
syms t t1 t2 real

q_acc(t) = ac0 + ac1 * t + ac2 * t ^ 2;
dq_acc = diff(q_acc, t);

q_const(t) = co0 + co1 * t;
dq_const = diff(q_const, t);

q_dec(t) = de0 + de1 * t + de2 * t ^ 2;
dq_dec = diff(q_dec, t);
%%

% acceleration constrain
accConstrain = [q_acc(ti) == qi ...
    dq_acc(ti) == 0 ...
    t1 - ti == t_acc];

% constant constraints
constConstain = [q_const(t1) == q_acc(t1) ...
    dq_const(t1) == dq_acc(t1) ...
    dq_const(t2) == dq_dec(t2) ...
    q_const(t2) == q_dec(t2)];

% deceleration constraints
decConstrain = [q_dec(tf) == qf ...
    dq_dec(tf) == 0 ...
    tf - t2 == t_dec];

sol = solve([accConstrain constConstain decConstrain]);

q_acc = subs(q_acc, [ac0 ac1 ac2], [sol.ac0 sol.ac1 sol.ac2]);
dq_acc = diff(q_acc, t);
ddq_acc = diff(dq_acc, t);

q_const = subs(q_const, [co0 co1], [sol.co0 sol.co1]);
dq_const = diff(q_const, t);
ddq_const = diff(dq_const, t);

q_dec = subs(q_dec, [de0 de1 de2], [sol.de0 sol.de1 sol.de2]);
dq_dec = diff(q_dec, t);
ddq_dec = diff(dq_dec, t);

%% plot position
figure(1);
subplot(3, 1, 1); hold on; grid on;
fplot(q_acc, [ti, double(sol.t1)], LineWidth = 3)
fplot(q_const, [double(sol.t1), double(sol.t2)], LineWidth = 3);
fplot(q_dec, [double(sol.t2), tf], LineWidth = 3);

%% plot velocity
subplot(3, 1, 2);
hold on; grid on;
fplot(dq_acc, [ti, double(sol.t1)], LineWidth = 3)
fplot(dq_const, [double(sol.t1), double(sol.t2)], LineWidth = 3);
fplot(dq_dec, [double(sol.t2), tf], LineWidth = 3);

%% plot acceleration
subplot(3, 1, 3);
hold on; grid on;
fplot(ddq_acc, [ti, double(sol.t1)], LineWidth = 3)
fplot(ddq_const, [double(sol.t1), double(sol.t2)], LineWidth = 3);
fplot(ddq_dec, [double(sol.t2), tf], LineWidth = 3);
