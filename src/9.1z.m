% 1. Векторизованное определение функции f(x)
function y = f(x)
    y = x .* (x <= 0) + sin(pi*x) .* (x > 0);
end

% 2. Предварительное вычисление полиномов Лежандра и коэффициентов
function [T, a] = precompute_legendre(max_n, x)
    % Инициализация
    T = zeros(max_n+1, length(x));
    a = zeros(max_n+1, 1);

    % Базовые случаи
    T(1,:) = ones(size(x)); % T_0
    T(2,:) = x;             % T_1

    % Рекуррентное вычисление полиномов
    for n = 2:max_n
        T(n+1,:) = ((2*n-1)*x.*T(n,:) - (n-1)*T(n-1,:))/n;
    end

    % Вычисление коэффициентов
    f_values = f(x);
    for k = 0:max_n
        Tk = T(k+1,:);
        numerator = trapz(x, Tk.*f_values);
        a(k+1) = (2*k+1)/2 * numerator;
    end
end

% 3. Основная программа
tic;

% Параметры
max_n = 50;
n_values = [10, 20, 50];
x = linspace(-1, 1, 1000);

% Предварительные вычисления
[T, a] = precompute_legendre(max_n, x);

% Вычисление частичных сумм
f_values = f(x);
F10 = sum(a(1:11) .* T(1:11,:), 1);
F20 = sum(a(1:21) .* T(1:21,:), 1);
F50 = sum(a(1:51) .* T(1:51,:), 1);

% Построение графиков
figure;
plot(x, f_values, 'k', 'LineWidth', 2); % f(x)
hold on;
plot(x, F10, 'b--', 'LineWidth', 1.5); % F10(x)
plot(x, F20, 'r-.', 'LineWidth', 1.5); % F20(x)
plot(x, F50, 'g:', 'LineWidth', 1.5);  % F50(x)
hold off;

% Альтернативный способ задания легенды без предупреждений
legend_labels = {
    'f(x)',
    'F_{10}(x)',
    'F_{20}(x)',
    'F_{50}(x)'
};

legend(legend_labels, 'Location', 'northwest');

xlabel('x');
ylabel('Значения функций');
title('Оптимизированная аппроксимация рядами Лежандра');
grid on;

toc;
