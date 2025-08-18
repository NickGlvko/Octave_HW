function dydx = odefunc(x, y)
    dydx = zeros(2,1);
    dydx(1) = y(2); % y1' = y2
    dydx(2) = 1 + cos(x) - y(1)*sin(x); % y2' = 1 + cos(x) - y1*sin(x)
end


xspan = [0 1];


y0 = [0; 1];


[x, y] = ode45(@odefunc, xspan, y0);


Y = y(:,1); % Y(x)
Y_prime = y(:,2); % Y'(x)


figure;
plot(x, Y, 'b', 'LineWidth', 2, 'DisplayName', 'Y(x)');
hold on;
plot(x, Y_prime, 'r', 'LineWidth', 2, 'DisplayName', "Y'(x)");
hold off;


xlabel('x');
ylabel('Значения функций');
title('Решение дифференциального уравнения');
legend('show');
grid on;
