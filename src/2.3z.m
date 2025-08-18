function plot_curves_and_find_intersections()

    [x, y] = meshgrid(linspace(-5, 5, 500), linspace(-5, 5, 500));


    eq1 = x.^2 + 0.7*x.*y + y.^2/2 - 5;
    eq2 = x.^2 + 0.3*x.*y - y.^2 - 1;


    figure;
    hold on;
    axis equal;
    grid on;


    contour(x, y, eq1, [0 0], 'b', 'LineWidth', 2);


    contour(x, y, eq2, [0 0], 'r', 'LineWidth', 2);


    intersections = find_intersections();


    plot(intersections(:,1), intersections(:,2), 'k*', 'MarkerSize', 12, 'LineWidth', 2);


    for i = 1:size(intersections, 1)
        text(intersections(i,1), intersections(i,2), sprintf('(%.3f, %.3f)', intersections(i,1), intersections(i,2)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end


    title('Пересечение кривых');
    xlabel('x');
    ylabel('y');
    legend('x^2+0.7xy+y^2/2=5', 'x^2+0.3xy-y^2=1', 'Точки пересечения');
    hold off;
end

function points = find_intersections()

    initial_guesses = [1.5 1.5; -1.5 1.5; 1.5 -1.5; -1.5 -1.5];

    points = [];
    options = optimset('Display', 'off', 'TolFun', 1e-10);

    for i = 1:size(initial_guesses, 1)
        try
            solution = fsolve(@equations_system, initial_guesses(i,:), options);


            if all(abs(equations_system(solution)) < 1e-6)

                is_new = true;
                for j = 1:size(points, 1)
                    if norm(solution - points(j,:)) < 0.1
                        is_new = false;
                        break;
                    end
                end

                if is_new
                    points = [points; solution];
                end
            end
        catch
            continue;
        end
    end
end

function F = equations_system(p)

    x = p(1);
    y = p(2);

    F = [x^2 + 0.7*x*y + y^2/2 - 5;
         x^2 + 0.3*x*y - y^2 - 1];
end


plot_curves_and_find_intersections();
