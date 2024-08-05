function [polynomials, d_polynomials, dd_polynomials] = create_spline(t_points, q_points, v_ini, v_fin)
    % this function create the n-1 polynomials of order 3 (cubic spline)
    % passing through the n given waypoints.

    % input: 1xn waypoints (position)
    %        1xn waypoints (time)
    %        initial velocity
    %        final velocity

    % output: n-1 x 4 polynomials. there is the number 4 because the cubic
    % spline have 4 unknown paramenters in its equation.

    syms t real

    n = size(q_points, 2); % numero di punti di passaggio

    a = sym("a", [n - 1, 4]); % number of segment

    polynomials = sym(zeros(n - 1, 1));

    for i = 1:n - 1
        polynomials(i) = a(i, 1) + a(i, 2) * t + a(i, 3) * t ^ 2 + a(i, 4) * t ^ 3;
    end

    % condition for the equation
    equations = [];

    % condition for the via-points
    for i = 1:n - 1
        equations = [equations; subs(polynomials(i), t, t_points(i)) == q_points(i)]; %#ok<*AGROW>
        equations = [equations; subs(polynomials(i), t, t_points(i + 1)) == q_points(i + 1)];
    end

    % condition for the velocity and acceleration in the via-points
    for i = 2:n - 1
        velocity_i = diff(polynomials(i - 1), t);
        velocity_i1 = diff(polynomials(i), t);
        acceleration_i = diff(velocity_i, t);
        acceleration_i1 = diff(velocity_i1, t);

        equations = [equations; subs(velocity_i, t, t_points(i)) == subs(velocity_i1, t, t_points(i))];
        equations = [equations; subs(acceleration_i, t, t_points(i)) == subs(acceleration_i1, t, t_points(i))];
    end

    % condition on initial and final velocity
    velocity__ = diff(polynomials(1), t);

    equations = [equations; subs(velocity__, t, t_points(1)) == v_ini]; % initial velocity
    equations = [equations; subs(velocity__, t, t_points(end)) == v_fin]; % final velocity

    sol = solve(equations);
    sol = struct2cell(sol);

    % coefficients = reshape(sol, 8, 1)

    coefficients = reshape(sol, 4, n - 1)';

    for i = 1:n - 1
        polynomials(i) = subs(polynomials(i), a(i, :), coefficients(i, :));
    end

    d_polynomials = diff(polynomials, t);
    dd_polynomials = diff(d_polynomials, t);

end
