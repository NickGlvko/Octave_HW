clear all;
close all;
clc;

f1 = @(x, y) sin(x + 2*y);
f2 = @(x, y, z) (z - 5).^2 + x.^2 - y + 2*y.^2 - 4;


A = [1, 1, 2];

[x, y] = meshgrid(linspace(-5, 5, 50), linspace(-5, 5, 50));

z1 = f1(x, y);
figure;
surf(x, y, z1);
hold on;
title('Поверхность z = sin(x + 2y)');
xlabel('x'); ylabel('y'); zlabel('z');
colorbar;


[x2, y2, z2] = meshgrid(linspace(-5, 5, 30), linspace(-5, 5, 30), linspace(0, 10, 30));
fv = isosurface(x2, y2, z2, f2(x2, y2, z2), 0);
patch(fv, 'FaceColor', 'red', 'EdgeColor', 'none');
title('Поверхности z = sin(x + 2y) и (z-5)^2 + x^2 - y + 2y^2 = 4');
alpha(0.01);
view(3);
grid on;


plot3(A(1), A(2), A(3), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');


[xx, yy] = meshgrid(linspace(-5, 5, 100), linspace(-5, 5, 100));
zz = f1(xx, yy);
points = [xx(:), yy(:), zz(:)];
dists = sqrt(sum((points - A).^2, 2));
[min_dist1, idx1] = min(dists);
closest_point1 = points(idx1, :);


points2 = fv.vertices;
dists2 = sqrt(sum((points2 - A).^2, 2));
[min_dist2, idx2] = min(dists2);
closest_point2 = points2(idx2, :);


plot3([A(1), closest_point1(1)], [A(2), closest_point1(2)], [A(3), closest_point1(3)], 'b-', 'LineWidth', 2);
plot3([A(1), closest_point2(1)], [A(2), closest_point2(2)], [A(3), closest_point2(3)], 'g-', 'LineWidth', 2);


D = pdist2(points, points2);
[min_dist_between, min_idx] = min(D(:));
[i, j] = ind2sub(size(D), min_idx);
closest_point_surf1 = points(i, :);
closest_point_surf2 = points2(j, :);

plot3([closest_point_surf1(1), closest_point_surf2(1)], ...
      [closest_point_surf1(2), closest_point_surf2(2)], ...
      [closest_point_surf1(3), closest_point_surf2(3)], 'm-', 'LineWidth', 2);

legend('Поверхность 1', 'Поверхность 2', 'Точка A', 'Расстояние до пов. 1', 'Расстояние до пов. 2', 'Расстояние между пов.');


fun1 = @(p) norm([p(1), p(2), f1(p(1), p(2))] - A);
options = optimset('Display', 'off');
p0 = closest_point1(1:2);
[opt_p1, opt_dist1] = fminsearch(fun1, p0, options);
opt_closest1 = [opt_p1(1), opt_p1(2), f1(opt_p1(1), opt_p1(2))];


fun2 = @(p) norm(p - A);
nonlcon = @(p) deal(f2(p(1), p(2), p(3)), []);
p0 = closest_point2;
[opt_p2, opt_dist2] = fmincon(fun2, p0, [], [], [], [], [], [], nonlcon, options);
opt_closest2 = opt_p2;


fun_between = @(p) norm([p(1), p(2), f1(p(1), p(2))] - [p(3), p(4), p(5)]);
nonlcon_between = @(p) deal(f2(p(3), p(4), p(5)), []);
p0 = [closest_point_surf1(1:2), closest_point_surf2];
lb = [-5, -5, -5, -5, 0];
ub = [5, 5, 5, 5, 10];
[opt_p_between, opt_dist_between] = fmincon(fun_between, p0, [], [], [], [], lb, ub, nonlcon_between, options);
opt_closest_between1 = [opt_p_between(1), opt_p_between(2), f1(opt_p_between(1), opt_p_between(2))];
opt_closest_between2 = [opt_p_between(3:5)];

fprintf('Метод перебора:\n');
fprintf('Кратчайшее расстояние от A до 1-й поверхности: %f\n', min_dist1);
fprintf('Кратчайшее расстояние от A до 2-й поверхности: %f\n', min_dist2);
fprintf('Кратчайшее расстояние между поверхностями: %f\n\n', min_dist_between);

fprintf('Метод оптимизации:\n');
fprintf('Уточненное расстояние от A до 1-й поверхности: %f\n', opt_dist1);
fprintf('Уточненное расстояние от A до 2-й поверхности: %f\n', opt_dist2);
fprintf('Уточненное расстояние между поверхностями: %f\n\n', opt_dist_between);


x_n1 = closest_point1(1);
y_n1 = closest_point1(2);
normal1 = [cos(x_n1 + 2*y_n1), 2*cos(x_n1 + 2*y_n1), -1];
normal1 = normal1 / norm(normal1);

% Вектор расстояния
dist_vec1 = (A - closest_point1) / norm(A - closest_point1);

% Угол между нормалью и вектором расстояния
angle1 = acosd(dot(normal1, dist_vec1));

% Для второй поверхности в точке closest_point2
% Нормаль к (z-5)^2 + x^2 - y + 2y^2 = 4
% Градиент: [2x, -1 + 4y, 2(z-5)]
x_n2 = closest_point2(1);
y_n2 = closest_point2(2);
z_n2 = closest_point2(3);
normal2 = [2*x_n2, -1 + 4*y_n2, 2*(z_n2 - 5)];
normal2 = normal2 / norm(normal2);

% Вектор расстояния
dist_vec2 = (A - closest_point2) / norm(A - closest_point2);

% Угол между нормалью и вектором расстояния
angle2 = acosd(dot(normal2, dist_vec2));

% Для расстояния между поверхностями
% Нормаль к первой поверхности в точке closest_point_surf1
x_ns1 = closest_point_surf1(1);
y_ns1 = closest_point_surf1(2);
normal_s1 = [cos(x_ns1 + 2*y_ns1), 2*cos(x_ns1 + 2*y_ns1), -1];
normal_s1 = normal_s1 / norm(normal_s1);

% Нормаль ко второй поверхности в точке closest_point_surf2
x_ns2 = closest_point_surf2(1);
y_ns2 = closest_point_surf2(2);
z_ns2 = closest_point_surf2(3);
normal_s2 = [2*x_ns2, -1 + 4*y_ns2, 2*(z_ns2 - 5)];
normal_s2 = normal_s2 / norm(normal_s2);

% Вектор расстояния между поверхностями
dist_vec_between = (closest_point_surf2 - closest_point_surf1) / norm(closest_point_surf2 - closest_point_surf1);

% Углы
angle_between1 = acosd(dot(normal_s1, dist_vec_between));
angle_between2 = acosd(dot(normal_s2, -dist_vec_between));

% Вывод углов
fprintf('Углы между отрезками и нормалями:\n');
fprintf('Для расстояния от A до 1-й поверхности: %f градусов\n', angle1);
fprintf('Для расстояния от A до 2-й поверхности: %f градусов\n', angle2);
fprintf('Для расстояния между поверхностями:\n');
fprintf('  Угол с нормалью 1-й поверхности: %f градусов\n', angle_between1);
fprintf('  Угол с нормалью 2-й поверхности: %f градусов\n', angle_between2);
