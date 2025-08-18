% 1. Векторизованное определение функции f(x)
function y = f(x)
    y = x .* (x <= 0) + sin(pi*x) .* (x > 0);
end

% 2. Вычисление одного полинома Лежандра (нерекурсивно)
function Tn = legendre_poly(n, x)
    if n == 0
        Tn = ones(size(x));
    elseif n == 1
        Tn = x;
    else
        T_prev_prev = ones(size(x));
        T_prev = x;
        for k = 2:n
            Tn = ((2*k-1)*x.*T_prev - (k-1)*T_prev_prev)/k;
            T_prev_prev = T_prev;
            T_prev = Tn;
        end
    end
end

% 3. Вычисление одного коэффициента a_k
function ak = compute_coeff(k, x)
    Tk = legendre_poly(k, x);
    f_values = f(x);
    numerator = trapz(x, Tk.*f_values);
    ak = (2*k+1)/2 * numerator;
end

% 4. Вычисление частичной суммы F_n(x)
function Fn = partial_sum(n, x)
    Fn = zeros(size(x));
    for k = 0:n
        ak = compute_coeff(k, x);
        Tk = legendre_poly(k, x);
        Fn = Fn + ak * Tk;
    end
end

% 5. Основная программа
tic;

% Параметры
x = linspace(-1, 1, 1000);
n_values = [10, 20, 50];

% Вычисление исходной функции
f_values = f(x);

% Вычисление частичных сумм без хранения всех полиномов
F10 = partial_sum(10, x);
F20 = partial_sum(20, x);
F50 = partial_sum(50, x);

% Построение графиков
figure;
plot(x, f_values, 'k', 'LineWidth', 2);
hold on;
plot(x, F10, 'b--', 'LineWidth', 1.5);
plot(x, F20, 'r-.', 'LineWidth', 1.5);
plot(x, F50, 'g:', 'LineWidth', 1.5);
hold off;

% Легенда
legend({'f(x)', 'F_{10}(x)', 'F_{20}(x)', 'F_{50}(x)'}, ...
       'Location', 'northwest');

xlabel('x');
ylabel('Значения функций');
title('Аппроксимация без хранения всех полиномов');
grid on;

toc;
