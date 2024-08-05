clear; close all; clc;

q = [0 3 5 10 12 0 -2 -10 24 0];
t = [0 2 5 7 9 11 15 22 25 30];

%% position
coeff_smooth = 0.4;
figure(1);
subplot(4, 1, 1); hold on;

legendLabels = {};

for i = coeff_smooth
    s = csaps(t, q, i);
    fnplt(s);
    legendLabels{end + 1} = ['p = ' num2str(i)]; %#ok<*SAGROW>
end

plot(t, q, 'ko', 'MarkerSize', 2, "LineWidth", 5, 'DisplayName', "data point");

legend(legendLabels, 'Location', 'northwest');
grid on

%% velocity
subplot(4, 1, 2); hold on;
legendLabels = {};

for i = coeff_smooth
    s = csaps(t, q, i);
    ds = fnder(s); % velocity
    fnplt(ds);
    legendLabels{end + 1} = ['p = ' num2str(i)];
end

legend(legendLabels, 'Location', 'northwest');
grid on

%% acceleration
subplot(4, 1, 3); hold on;

legendLabels = {};

for i = coeff_smooth
    s = csaps(t, q, i);
    dds = fnder(s, 2); % Acceleration
    fnplt(dds);
    legendLabels{end + 1} = ['p = ' num2str(i)];
end

legend(legendLabels, 'Location', 'northwest');
grid on

%% jerk

subplot(4, 1, 4); hold on;

legendLabels = {};

for i = coeff_smooth
    s = csaps(t, q, i);
    ddds = fnder(s, 3); % velocity
    fnplt(ddds);
    legendLabels{end + 1} = ['p = ' num2str(i)];
end

legend(legendLabels, 'Location', 'northwest');
grid on
