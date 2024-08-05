clc; clearvars; close all;

syms a0 a1 a2 a3 a4 a5 a6 a7 real
syms t

%% Parameters %%
ti = 0;
tf = 5;
qi = 0;
qf = 10;
dqi = 0;
dqf = 0;
ddqi = 0;
ddqf = 0;
dddqi = 0;
dddqf = 0;
%%%%%%%%%%%%%%%%

%% linear trajectory %%
q(t) = a0 + a1 * (t - ti);

lin_equations = [q(ti) == qi, q(tf) == qf];
lin_sol = solve(lin_equations);

q(t) = subs(q(t), [a0 a1], [lin_sol.a0, lin_sol.a1]);
dq(t) = diff(q, t);
ddq(t) = diff(dq, t);

figure(1)
subplot(3, 1, 1);
fplot(q, [ti, tf], "LineWidth", 2); title("POSITION"); xlabel("time"); ylabel("joint position"); grid on;
subplot(3, 1, 2);

fplot(dq, [ti, tf], "LineWidth", 2);
title("VELOCITY"); xlabel("time"); ylabel("joint velocity"); grid on;

subplot(3, 1, 3);
fplot(ddq, [ti, tf], "LineWidth", 2);
title("ACCELERATION"); xlabel("time"); ylabel("joint acceleration"); grid on;

%% parabolic trajectory %%
% acceleration
qa(t) = a0 + a1 * (t - ti) + a2 * (t - ti) ^ 2;
dqa = diff(qa, t);

qm = (qi + qf) / 2;
tm = (ti + tf) / 2;
dqm = 10;

acc_par_equations = [qa(ti) == qi, qa(tm) == qm, dqa(ti) == dqi];
par_sol = solve(acc_par_equations, [a0, a1, a2]);

qa = subs(qa, [a0 a1 a2], [par_sol.a0, par_sol.a1, par_sol.a2]);
dqa = diff(qa, t);
ddqa = diff(dqa, t);

% decelleration
qd(t) = a0 + a1 * (t - tm) + a2 * (t - tm) ^ 2;
dqd(t) = diff(qd, t);

dec_par_equations = [qd(tm) == qm, qd(tf) == qf, dqd(tf) == dqf];
dec_par_sol = solve(dec_par_equations);

qd = subs(qd, [a0, a1, a2], [dec_par_sol.a0, dec_par_sol.a1, dec_par_sol.a2]);
dqd = diff(qd, t);
ddqd = diff(dqd, t);

figure(2);
subplot(3, 1, 1);
fplot(qa, [ti, tm], "LineWidth", 2); title("POSITION"); xlabel("time"); ylabel("joint position"); grid on; hold on;
fplot(qd, [tm, tf], "LineWidth", 2);

subplot(3, 1, 2);
title("VELOCITY"); xlabel("time"); ylabel("joint velocity"); grid on; hold on;
fplot(dqa, [ti, tm], "LineWidth", 2);
fplot(dqd, [tm, tf], "LineWidth", 2);

subplot(3, 1, 3);
title("ACCELERATION"); xlabel("time"); ylabel("joint acceleration"); grid on; hold on;
fplot(ddqa, [ti, tm], "LineWidth", 2);
fplot(ddqd, [tm, tf], "LineWidth", 2);

%% cubic spline %%

q(t) = a0 + a1 * (t - ti) + a2 * (t - ti) ^ 2 + a3 * (t - ti) ^ 3;
dq(t) = diff(q, t);
ddq(t) = diff(dq, t);

cubic_equations = [q(ti) == qi, q(tf) == qf, dq(ti) == dqi, dq(tf) == dqf];

sol_cubic = solve(cubic_equations);

q(t) = subs(q, [a0, a1, a2, a3], [sol_cubic.a0, sol_cubic.a1, sol_cubic.a2, sol_cubic.a3]);
dq(t) = diff(q, t);
ddq(t) = diff(dq, t);
dddq(t) = diff(ddq, t);

figure(3);
subplot(4, 1, 1);
fplot(q, [ti, tf], "LineWidth", 2); title("POSITION"); xlabel("time"); ylabel("joint position"); grid on;
subplot(4, 1, 2);

fplot(dq, [ti, tf], "LineWidth", 2);
title("VELOCITY"); xlabel("time"); ylabel("joint velocity"); grid on;

subplot(4, 1, 3);
fplot(ddq, [ti, tf], "LineWidth", 2);
title("ACCELERATION"); xlabel("time"); ylabel("joint acceleration"); grid on;

subplot(4, 1, 4);
fplot(dddq, [ti, tf], "LineWidth", 2);
title("JERK"); xlabel("time"); ylabel("joint jerk"); grid on;

%% 5th-ORDER TRAJECTORY %%
q(t) = a0 + (a1 * (t - ti)) + (a2 * (t - ti) ^ 2) + (a3 * (t - ti) ^ 3) + (a4 * (t - ti) ^ 4) + (a5 * (t - ti) ^ 5);
dq(t) = diff(q, t);
ddq(t) = diff(dq, t);

fifth_equations = [q(ti) == qi, q(tf) == qf, dq(ti) == dqi, dq(tf) == dqf, ddq(ti) == ddqi, ddq(tf) == ddqf];
sol_5 = solve(fifth_equations);

q(t) = subs(q, [a0, a1, a2, a3, a4, a5], [sol_5.a0, sol_5.a1, sol_5.a2, sol_5.a3, sol_5.a4, sol_5.a5]);
dq(t) = diff(q, t);
ddq(t) = diff(dq, t);
dddq(t) = diff(ddq, t);

figure(4);
subplot(4, 1, 1);
fplot(q, [ti, tf], "LineWidth", 2); title("POSITION"); xlabel("time"); ylabel("joint position"); grid on;
subplot(4, 1, 2);

fplot(dq, [ti, tf], "LineWidth", 2);
title("VELOCITY"); xlabel("time"); ylabel("joint velocity"); grid on;

subplot(4, 1, 3);
fplot(ddq, [ti, tf], "LineWidth", 2);
title("ACCELERATION"); xlabel("time"); ylabel("joint acceleration"); grid on;

subplot(4, 1, 4);
fplot(dddq, [ti, tf], "LineWidth", 2);
title("JERK"); xlabel("time"); ylabel("joint jerk"); grid on;

%% 7th-order trajectory %%
q(t) = a0 + (a1 * (t - ti)) + (a2 * (t - ti) ^ 2) + (a3 * (t - ti) ^ 3) + (a4 * (t - ti) ^ 4) + (a5 * (t - ti) ^ 5) + (a6 * (t - ti) ^ 6) + (a7 * (t - ti) ^ 7);
dq(t) = diff(q, t);
ddq(t) = diff(dq, t);
dddq(t) = diff(ddq, t);

seventh_equations = [q(ti) == qi, q(tf) == qf, dq(ti) == dqi, dq(tf) == dqf, ddq(ti) == ddqi, ddq(tf) == ddqf, dddq(ti) == dddqi, dddq(tf) == dddqf];
sol_7 = solve(seventh_equations);

q(t) = subs(q, [a0, a1, a2, a3, a4, a5, a6, a7], [sol_7.a0, sol_7.a1, sol_7.a2, sol_7.a3, sol_7.a4, sol_7.a5, sol_7.a6, sol_7.a7]);
dq(t) = diff(q, t);
ddq(t) = diff(dq, t);
dddq(t) = diff(ddq, t);

figure(5);
subplot(4, 1, 1);
fplot(q, [ti, tf], "LineWidth", 2); title("POSITION"); xlabel("time"); ylabel("joint position"); grid on;
subplot(4, 1, 2);

fplot(dq, [ti, tf], "LineWidth", 2);
title("VELOCITY"); xlabel("time"); ylabel("joint velocity"); grid on;

subplot(4, 1, 3);
fplot(ddq, [ti, tf], "LineWidth", 2);
title("ACCELERATION"); xlabel("time"); ylabel("joint acceleration"); grid on;

subplot(4, 1, 4);
fplot(dddq, [ti, tf], "LineWidth", 2);
title("JERK"); xlabel("time"); ylabel("joint jerk"); grid on;
