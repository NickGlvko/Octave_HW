clear all;
close all;
clc;


f = @(y) sin(y) .* log(y) .* atan(y);

F = @(x) integral(f, 0, x, 'ArrayValued', true);


x = linspace(0.01, 20, 1000);
y_F = arrayfun(F, x);


figure;
plot(x, y_F, 'b-', 'LineWidth', 2);
hold on;
grid on;
title('График функции F(x) = ∫₀ˣ sin(z)ln(z)arctg(z) dz');
xlabel('x');
ylabel('F(x)');

sign_changes = find(diff(sign(y_F)));
roots_x = zeros(1, length(sign_changes));

for i = 1:length(sign_changes)
    idx = sign_changes(i);
    roots_x(i) = fzero(F, [x(idx), x(idx+1)]);
    plot(roots_x(i), 0, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
end


sign_changes_f = find(diff(sign(f(x))));
extrema_x = zeros(1, length(sign_changes_f));

for i = 1:length(sign_changes_f)
    idx = sign_changes_f(i);
    extrema_x(i) = fzero(f, [x(idx), x(idx+1)]);
    plot(extrema_x(i), F(extrema_x(i)), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
end


extrema_type = cell(1, length(extrema_x));
for i = 1:length(extrema_x)
    if i == 1
        left = extrema_x(i) - 0.1;
    else
        left = extrema_x(i-1);
    end

    if i == length(extrema_x)
        right = extrema_x(i) + 0.1;
    else
        right = extrema_x(i+1);
    end

    test_point1 = (extrema_x(i) + left)/2;
    test_point2 = (extrema_x(i) + right)/2;

    f_val1 = f(test_point1);
    f_val2 = f(test_point2);

    if f_val1 > 0 && f_val2 < 0
        extrema_type{i} = 'max';
    elseif f_val1 < 0 && f_val2 > 0
        extrema_type{i} = 'min';
    else
        extrema_type{i} = '?';
    end
end


fprintf('Корни функции F(x) (F(x) = 0) на интервале (0, 20):\n');
disp(roots_x);

fprintf('\nЭкстремумы функции F(x) на интервале (0, 20):\n');
for i = 1:length(extrema_x)
    fprintf('x = %f: %s, F(x) = %f\n', extrema_x(i), extrema_type{i}, F(extrema_x(i)));
end


legend('F(x)', 'Корни F(x)=0', 'Экстремумы F(x)', 'Location', 'best');


figure;
plot(x, f(x), 'r-', 'LineWidth', 2);
hold on;
plot(extrema_x, zeros(size(extrema_x)), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
grid on;
title('График функции f(x) = sin(x)ln(x)arctg(x) (производная F(x))');
xlabel('x');
ylabel('f(x)');
legend('f(x)', 'Нули f(x) (экстремумы F(x))', 'Location', 'best');
