clear all;
close all;
clc;


A_x = -1.6;
A_y = 2;


phi = linspace(0, 2*pi, 3000);
r_squared = 2 * abs(cos(2 * phi));
r = sqrt(r_squared);
x1 = r .* cos(phi);
y1 = r .* sin(phi);

distance_squared = @(phi) ...
    (sqrt(2 * abs(cos(2*phi))) .* cos(phi) - A_x).^2 + ...
    (sqrt(2 * abs(cos(2*phi))) .* sin(phi) - A_y).^2;


options = optimset('Display','off', 'TolX', 1e-8);


phi_candidates = linspace(0, 2*pi, 20);
min_val = Inf;

for i = 1:length(phi_candidates)
    phi0 = phi_candidates(i);
    [phi_opt, val] = fminunc(distance_squared, phi0, options);
    if val < min_val
        min_val = val;
        phi_best = phi_opt;
    end
end

r_best = sqrt(2 * abs(cos(2 * phi_best)));
x_min1 = r_best * cos(phi_best);
y_min1 = r_best * sin(phi_best);
D_min1 = sqrt((x_min1 - A_x)^2 + (y_min1 - A_y)^2);


[x, y] = meshgrid(linspace(-5, 5, 500));
equation = x.^2 + 2*x.*y - y.^2 + 3*y - x - 10;


F = @(u) [
    2*(u(1) - A_x) + u(3)*(2*u(1) + 2*u(2) - 1);
    2*(u(2) - A_y) + u(3)*(2*u(1) - 2*u(2) + 3);
    u(1)^2 + 2*u(1)*u(2) - u(2)^2 + 3*u(2) - u(1) - 10
];
u0 = [-2; 2; 0];
[sol, ~, info] = fsolve(F, u0, options);
x_min2 = sol(1);
y_min2 = sol(2);
D_min2 = (x_min2 - A_x)^2 + (y_min2 - A_y)^2;


v1 = [x_min1 - A_x, y_min1 - A_y];
v2 = [x_min2 - A_x, y_min2 - A_y];

dot_product = dot(v1, v2);
norm_v1 = norm(v1);
norm_v2 = norm(v2);

cos_theta = dot_product / (norm_v1 * norm_v2);
theta_rad = acos(cos_theta);
theta_deg = rad2deg(theta_rad);

D1_txt = num2str(sqrt(D_min1), '%.5f')
D2_txt = num2str(sqrt(D_min2), '%.5f')
angle_text = num2str(theta_deg, '%.1f')

figure;
plot(x1, y1, 'b-', 'LineWidth', 2); hold on;
contour(x, y, equation, [0 0], 'r-', 'LineWidth', 2);
plot(A_x, A_y, 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'none', 'LineWidth', 1);
text(A_x + 0.1, A_y + 0.1, 'A (-1.6, 2)', 'FontSize', 10);


plot(x_min1, y_min1, 'bo', 'MarkerFaceColor', 'b');
line([A_x x_min1], [A_y y_min1], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);


plot(x_min2, y_min2, 'ro', 'MarkerFaceColor', 'r');
line([A_x x_min2], [A_y y_min2], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);

text(A_x + 0.7, A_y - 0.4, D1_txt, 'FontSize', 10);
text(A_x - 1.2, A_y - 0.5, D2_txt, 'FontSize', 10);
text(A_x - 0.1, A_y - 0.3, angle_text, 'FontSize', 10);



axis equal;
grid on;
title('Кратчайшие расстояния от точки A до кривых');
xlabel('x');
ylabel('y');
legend({'r^2 = 2|cos(2\phi)|', ...
        'x^2 + 2xy - y^2 + 3y - x = 10', ...
        'Точка A', ...
        'Ближайшая точка на первой кривой', ...
        'Расстояние до первой кривой', ...
        'Ближайшая точка на второй кривой', ...
        'Расстояние до второй кривой'}, ...
        'Location', 'bestoutside');

fprintf('=== Результаты ===\n');
fprintf('До первой кривой:\n  Точка: (%.4f, %.4f)\n  Расстояние: %.6f\n\n', ...
    x_min1, y_min1, sqrt(D_min1));
fprintf('До второй кривой:\n  Точка: (%.4f, %.4f)\n  Расстояние: %.6f\n', ...
    x_min2, y_min2, sqrt(D_min2));
fprintf('\nУгол между отрезками: %.2f градусов\n', theta_deg);


phi_samples = linspace(0, 2*pi, 20);
x2_samples = linspace(-3, 3, 10);
y2_samples = linspace(-3, 3, 10);

best_dist = Inf;

for i = 1:length(phi_samples)
    for j = 1:length(x2_samples)
        for k = 1:length(y2_samples)
            phi0 = phi_samples(i);
            x0 = x2_samples(j);
            y0 = y2_samples(k);

            u0 = [phi0; x0; y0];

            penaltyFun = @(u) ...
                (sqrt(2 * abs(cos(2*u(1)))) * cos(u(1)) - u(2))^2 + ...
                (sqrt(2 * abs(cos(2*u(1)))) * sin(u(1)) - u(3))^2 + ...
                1e4 * (u(2)^2 + 2*u(2)*u(3) - u(3)^2 + 3*u(3) - u(2) - 10)^2;

            [u_opt, val] = fminunc(penaltyFun, u0, options);

            if val < best_dist
                best_dist = val;
                best_u = u_opt;
            end
        end
    end
end


phi_crv = best_u(1);
x_crv2 = best_u(2);
y_crv2 = best_u(3);

r_crv1 = sqrt(2 * abs(cos(2 * phi_crv)));
x_crv1 = r_crv1 * cos(phi_crv);
y_crv1 = r_crv1 * sin(phi_crv);

D_min_crv = sqrt((x_crv1 - x_crv2)^2 + (y_crv1 - y_crv2)^2);


plot(x_crv1, y_crv1, 'mo', 'MarkerFaceColor', 'm');
plot(x_crv2, y_crv2, 'mo', 'MarkerFaceColor', 'm');
line([x_crv1 x_crv2], [y_crv1 y_crv2], 'Color', 'm', 'LineStyle', '--', 'LineWidth', 2);


mid_x = (x_crv1 + x_crv2) / 2;
mid_y = (y_crv1 + y_crv2) / 2;
text(mid_x + 0.2, mid_y, ['\itD = ' num2str(D_min_crv, '%.4f')], 'Color', 'm', 'FontSize', 10);


fprintf('\n=== Кратчайшее расстояние между кривыми ===\n');
fprintf('Точка на первой кривой: (%.4f, %.4f)\n', x_crv1, y_crv1);
fprintf('Точка на второй кривой: (%.4f, %.4f)\n', x_crv2, y_crv2);
fprintf('Расстояние: %.6f\n', D_min_crv);



