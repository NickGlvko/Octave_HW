function y = sigma(x)
    y = sqrt(2*pi) - abs(x - log(pi^2)) .* exp(-abs(sin(x - sqrt(10))));
end

x = linspace(-3, 4, 1000);
y = sigma(x);


roots = [];
for i = 1:length(x)-1
    if y(i)*y(i+1) < 0
        root = fzero(@sigma, [x(i), x(i+1)]);
        roots = [roots, root];
    end
end


[max_val, max_idx] = max(y);
[min_val, min_idx] = min(y);
x_max = x(max_idx);
x_min = x(min_idx);


disp('Корни функции:');
disp(roots);
disp('Максимальное значение:');
disp([x_max, max_val]);
disp('Минимальное значение:');
disp([x_min, min_val]);


figure;
plot(x, sigma(x));
hold on;
plot(roots, zeros(size(roots)), 'ro');
plot(x_max, max_val, 'g*');
plot(x_min, min_val, 'm*');
xlabel('x');
ylabel('\sigma(x)');
title('График функции \sigma(x) (кликните по графику для координат)');
grid on;
hold off;


while true
    try
        [x_click, y_click] = ginput(1);
        if isempty(x_click)
            break;
        end

        hold on;
        plot(x_click, y_click, 'ko', 'MarkerSize', 8, 'LineWidth', 1);
        text(x_click, y_click, [' (', num2str(x_click,3), ', ', num2str(y_click,3), ')'], ...
            'VerticalAlignment', 'bottom');
        hold off;
    catch
        break;
    end
end


function [sum_result, terms_count] = calculate_series(x, tolerance = 1e-6, max_terms = 1e5)

    sum_result = 0;
    terms_count = 0;

    for k = 1:max_terms
        term = sin((2*k-1)*x) / (2*k-1);
        sum_result = sum_result + term;
        terms_count = terms_count + 1;


        if abs(term) < tolerance
            break;
        end
    end
end


x = 1;
tolerance = 1e-8;
max_terms = 1e6;


[result, k] = calculate_series(x, tolerance, max_terms);


disp(['Сумма ряда для x = ', num2str(x), ': ', num2str(result)]);
disp(['Количество учтенных слагаемых: ', num2str(k)]);
