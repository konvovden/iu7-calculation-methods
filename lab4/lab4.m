function lab4()
    clc();
    warning('off', 'all');

    debug = 1;
    delaySeconds = 3.0;

    a = 0;
    b = 1;
    e = 1e-2;
    d = 1e-6;  

    [x, y, N] = NewtonMethod(a, b, e, d, debug, delaySeconds);
   
    hold off;
    fplot(@f, [a, b]);
    hold on;

    fprintf('RESULT: e = %f | N = %d | x* = %.10f | f(x*) = %.10f', e, N, x, y)

    scatter(x, y, 'g', 'filled');
    
    hold off;
end

function y = f(x)
    y = sin((power(x, 4) + power(x, 3) - 3 * x + 3 - power(30, 1/3)) / 2) + tanh((4 * sqrt(3) * power(x, 3) - 2 * x - 6 * sqrt(2) + 1) / (-2 * sqrt(3) * power(x, 3) + x + 3 * sqrt(2))) + 1.2;
end

function [x, y, N] = NewtonMethod(a, b, e, d, debug, delaySeconds)
    x = (b + a) / 2;

    f2 = (f(x - d) - 2*f(x) + f(x + d)) / (d^2);

    i = 0;
    
    while 1
        i = i + 1;
        f1 = (f(x + d) - f(x - d)) / (2 * d);

        new_x = x - f1/f2;

        if debug
            fprintf('%d: x = %.10f | f1 = %.10f\n', i, x, f1);

            hold off;
            fplot(@(x) (f(x + d) - f(x - d)) / (2 * d), [a, b]);
            hold on;
            
            plot([0, 1], [0, 0], 'Color', 'black');
            scatter(x, f1, 'filled', 'r');
            scatter(new_x, 0, 'r');
            plot([x, new_x], [f1, 0], 'Color', 'r');
            
            pause(delaySeconds);
        end

        if abs(f1) < e
            break;
        end

        x = new_x;
    end

    y = f(x);
    N = i;
end