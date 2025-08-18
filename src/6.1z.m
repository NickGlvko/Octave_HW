% Часть a)
roots_original = 1:23;
poly_coeffs = poly(roots_original);

figure;
plot(roots_original, zeros(size(roots_original)), 'ko', 'MarkerFaceColor', 'k');
hold on;
title('Корни полинома 23 степени');
xlabel('Re');
ylabel('Im');
grid on;

% Часть b)
roots_calculated = roots(poly_coeffs);
plot(real(roots_calculated), imag(roots_calculated), 'r*');

% Часть d)
refined_roots = zeros(size(roots_original));
for i = 1:length(roots_original)
    initial_guess = roots_original(i);
    refined_roots(i) = fzero(@(x) polyval(poly_coeffs, x), initial_guess);
end
plot(refined_roots, zeros(size(refined_roots)), 'gx', 'MarkerSize', 10);

% Часть e)
P = @(x) prod(x - (1:23));
direct_roots = zeros(size(roots_original));
for i = 1:length(roots_original)
    initial_guess = roots_original(i);
    direct_roots(i) = fzero(P, initial_guess);
end
plot(direct_roots, zeros(size(direct_roots)), 'ms', 'MarkerSize', 8);

legend('Исходные корни', 'Вычисленные корни', 'Уточненные корни (fzero)', 'Прямые корни (fzero)');
