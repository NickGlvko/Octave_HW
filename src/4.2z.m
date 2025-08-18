function gauss_method_comparison()
    % Основная функция сравнения методов
    sizes = [5, 10, 20];

    % Отключаем предупреждения о сингулярных матрицах
    warning('off', 'all');

    % Заголовок таблицы
    fprintf('%-5s %-20s %-20s %-20s %-20s\n', 'n', 'Gauss (column)', 'Gauss (full)', 'MATLAB \\', 'inv(H)*b');
    fprintf('%s\n', repmat('-', 85, 1));

    for n = sizes
        % Создаем матрицу Гильберта и вектор b
        H = hilb(n);
        b = ones(n, 1);

        % Решаем систему разными методами
        x_col = gauss_column_pivot(H, b);
        x_full = gauss_full_pivot(H, b);
        x_slash = H \ b;

        % Проверяем обусловленность перед вычислением обратной матрицы
        rcond_val = rcond(H);
        if rcond_val < eps
            x_inv = NaN(n, 1);
            res_inv = NaN;
        else
            x_inv = inv(H) * b;
            res_inv = norm(H * x_inv - b);
        end

        % Вычисляем невязки
        res_col = norm(H * x_col - b);
        res_full = norm(H * x_full - b);
        res_slash = norm(H * x_slash - b);

        % Выводим результаты
        if isnan(res_inv)
            fprintf('%-5d %-20.4e %-20.4e %-20.4e %-20s\n', ...
                    n, res_col, res_full, res_slash, 'NaN (singular)');
        else
            fprintf('%-5d %-20.4e %-20.4e %-20.4e %-20.4e\n', ...
                    n, res_col, res_full, res_slash, res_inv);
        end
    end

    % Включаем предупреждения обратно
    warning('on', 'all');
end

function x = gauss_column_pivot(A, b)
    % Метод Гаусса с выбором главного элемента по столбцу
    n = size(A, 1);
    Ab = [A, b];

    for k = 1:n-1
        % Выбор главного элемента в столбце
        [~, pivot_row] = max(abs(Ab(k:n, k)));
        pivot_row = pivot_row + k - 1;

        % Перестановка строк
        Ab([k, pivot_row], :) = Ab([pivot_row, k], :);

        % Исключение
        for i = k+1:n
            factor = Ab(i, k) / Ab(k, k);
            Ab(i, k:end) = Ab(i, k:end) - factor * Ab(k, k:end);
        end
    end

    % Обратный ход
    x = zeros(n, 1);
    for i = n:-1:1
        x(i) = (Ab(i, end) - Ab(i, i+1:n) * x(i+1:n)) / Ab(i, i);
    end
end

function x = gauss_full_pivot(A, b)
    % Метод Гаусса с полным выбором главного элемента
    n = size(A, 1);
    Ab = [A, b];
    col_index = 1:n;

    for k = 1:n-1
        % Выбор главного элемента во всей подматрице
        [max_val, pivot] = max(reshape(abs(Ab(k:n, k:n)), [], (n-k+1)*(n-k+1)));
        [pivot_row, pivot_col] = ind2sub([n-k+1, n-k+1], pivot);
        pivot_row = pivot_row + k - 1;
        pivot_col = pivot_col + k - 1;

        % Перестановка строк
        Ab([k, pivot_row], :) = Ab([pivot_row, k], :);

        % Перестановка столбцов
        Ab(:, [k, pivot_col]) = Ab(:, [pivot_col, k]);
        col_index([k, pivot_col]) = col_index([pivot_col, k]);

        % Исключение
        for i = k+1:n
            factor = Ab(i, k) / Ab(k, k);
            Ab(i, k:end) = Ab(i, k:end) - factor * Ab(k, k:end);
        end
    end

    % Обратный ход
    x = zeros(n, 1);
    for i = n:-1:1
        x(i) = (Ab(i, end) - Ab(i, i+1:n) * x(i+1:n)) / Ab(i, i);
    end

    % Восстановление порядка переменных
    [~, inv_col_index] = sort(col_index);
    x = x(inv_col_index);
end

% Запускаем сравнение методов
gauss_method_comparison();
