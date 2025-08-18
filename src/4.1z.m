function result = SINT(x, N)
    result = 0;
    term = x;
    result = result + term;

    for n = 1:N-1
        term = -x^2 / ((2*n)*(2*n+1)) * term;
        result = result + term;
    end
end

function result = EXPT(x, N)
    result = 0;
    term = 1;
    result = result + term;

    for n = 1:N-1
        term = x / n * term;
        result = result + term;
    end
end

function compare_results()
    x_values = [-500, -100, -50, 50, 100, 500];
    N_values = [40, 80, 200, 400];

    fprintf('%-10s %-10s %-15s %-15s %-15s %-15s\n', 'x', 'N', 'SINT(x,N)', 'sin(x)', 'EXPT(x,N)', 'exp(x)');
    fprintf('%s\n', repmat('-', 85, 1));

    for x = x_values
        for N = N_values
            sin_taylor = SINT(x, N);
            sin_real = sin(x);
            exp_taylor = EXPT(x, N);
            exp_real = exp(x);
            fprintf('%-10d %-10d %-15.6g %-15.6g %-15.6g %-15.6g\n', x, N, sin_taylor, sin_real, exp_taylor, exp_real);
        end
        fprintf('%s\n', repmat('-', 85, 1));
    end
end

compare_results();
