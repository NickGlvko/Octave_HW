clear all;
close all;


x = linspace(-pi, pi, 50);
y = linspace(-pi, pi, 50);
[X, Y] = meshgrid(x, y);


Z = 20 - X.^2 - Y.^2;


figure;
subplot(1,2,1);
surf(X, Y, Z);
title('Поверхность (surf)');
xlabel('x');
ylabel('y');
zlabel('z');
axis equal;
grid on;

subplot(1,2,2);
surfc(X, Y, Z);
title('Поверхность с контурами (surfc)');
xlabel('x');
ylabel('y');
zlabel('z');
axis equal;
grid on;


x0 = 0;
y0 = -1;
z0 = 20 - x0^2 - y0^2;


dz_dx = -2*x0;
dz_dy = -2*y0;


normal_vector = [dz_dx, dz_dy, -1];
normal_vector = normal_vector / norm(normal_vector);


figure;
surf(X, Y, Z);
hold on;


plot3(x0, y0, z0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');


quiver3(x0, y0, z0, normal_vector(1), normal_vector(2), normal_vector(3), 'r', 'LineWidth', 2);
title('Поверхность с вектором нормали');
xlabel('x');
ylabel('y');
zlabel('z');
axis equal;
grid on;
hold off;


R = 0.1;
phi = linspace(0, 6*pi, 300);


r = R * phi;
x_spiral = r .* cos(phi);
y_spiral = r .* sin(phi);


x_spiral = x_spiral + x0;
y_spiral = y_spiral + y0;


z_spiral = 20 - x_spiral.^2 - y_spiral.^2;


figure;
surf(X, Y, Z);
hold on;


plot3(x_spiral, y_spiral, z_spiral, 'r-', 'LineWidth', 2);


plot3(x_spiral, y_spiral, zeros(size(z_spiral)), 'b--', 'LineWidth', 1.5);


plot3(x0, y0, z0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
plot3(x0, y0, 0, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');

title('Спираль Архимеда на поверхности и ее проекция');
xlabel('x');
ylabel('y');
zlabel('z');
legend('Поверхность', 'Спираль на поверхности', 'Проекция спирали', 'Начальная точка (поверхность)', 'Начальная точка (проекция)');
axis equal;
grid on;
hold off;
