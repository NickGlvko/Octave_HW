function plot_R_function()

    x = linspace(-2*pi, 2*pi, 1000);


    real_part = zeros(size(x));
    imag_part = zeros(size(x));


    for i = 1:length(x)
        xi = x(i);

        term1 = 0;
        if abs(2*sin(xi)) <= 1
            term1 = acos(2*sin(xi));
        else
            term1 = acos(complex(2*sin(xi)));
        end


        term2 = 0;
        if sin(xi) >= 0
            term2 = sqrt(sin(xi));
        else
            term2 = sqrt(complex(sin(xi)));
        end


        term3 = 0;
        if xi >= 0
            term3 = sin(xi)*cos(sqrt(xi));
        else
            term3 = sin(xi)*cos(sqrt(complex(xi)));
        end


        term4 = 0;
        if xi > 0 && xi ~= 1
            term4 = sqrt(-xi) * (abs(xi)^(1/log(xi)));
        end


        R = term1 + term2 + term3 + term4;
        real_part(i) = real(R);
        imag_part(i) = imag(R);
    end


    figure;

    subplot(2,1,1);
    plot(x, real_part, 'b', 'LineWidth', 1.5);
    title('Действительная часть R(x)');
    xlabel('x');
    ylabel('Re(R)');
    grid on;

    subplot(2,1,2);
    plot(x, imag_part, 'r', 'LineWidth', 1.5);
    title('Мнимая часть R(x)');
    xlabel('x');
    ylabel('Im(R)');
    grid on;
end

% Вызов функции (убедитесь, что это в отдельном файле или в консоли)
plot_R_function();
