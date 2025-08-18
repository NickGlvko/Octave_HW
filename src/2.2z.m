function euler_mascheroni_constant()
    n_max = 2000;
    n_values = 1:n_max;
    S_values = zeros(size(n_values));


    harmonic_partial = 0;

    for n = n_values
        harmonic_partial = harmonic_partial + 1/n;
        S_values(n) = harmonic_partial - log(n);
    end


    figure;
    plot(n_values, S_values, 'b-', 'LineWidth', 1.5);
    hold on;


    gamma_const = 0.5772156649;
    plot([n_values(1), n_values(end)], [gamma_const, gamma_const], 'r--',
         'LineWidth', 1.5, 'DisplayName', sprintf('γ ≈ %.10f', gamma_const));


    title('Сходимость к постоянной Эйлера-Маскерони');
    xlabel('n');
    ylabel('S(n)');
    legend('S(n)', 'γ', 'Location', 'southeast');
    grid on;
    hold off;


    printf('При n = %d:\n', n_max);
    printf('S(n) = %.10f\n', S_values(end));
    printf('γ    = %.10f\n', gamma_const);
    printf('Разница: %.10f\n', abs(S_values(end) - gamma_const));
end


euler_mascheroni_constant();
