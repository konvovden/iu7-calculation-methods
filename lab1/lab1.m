function lab1()
    debug = 1;

    a = 0;
    b = 1;
    e = 0.01;

    [x, y, N] = bitwiseSearch(a, b, e, debug);
   
    fprintf('RESULT: e = %f | N = %d | x* = %.10f | f(x*) = %.10f', e, N, x, y)

end

function y = f(x)
    y = sin((power(x, 4) + power(x, 3) - 3 * x + 3 - power(30, 1/3)) / 2) + tanh((4 * sqrt(3) * power(x, 3) - 2 * x - 6 * sqrt(2) + 1) / (-2 * sqrt(3) * power(x, 3) + x + 3 * sqrt(2))) + 1.2;
end

function [x, y, N] = bitwiseSearch(a, b, e, debug)
    i = 0;
    x0 = a;
    f0 = f(x0);
    delta = (b - a) / 4;

    if debug
        fprintf('%d: x%d = %.10f | y%d = %.10f\n', 0, 0, x0, 0, f0)
    end

    while 1

        i = i + 1;

        x1 = x0 + delta;
        f1 = f(x1);

        if debug
            fprintf('%d: x%d = %.10f | y%d = %.10f\n', i, i, x1, i, f1)
        end

        if f0 <= f1 || x1 <= a || x1 >= b
            if abs(delta) < e
                break;
            else
                delta = -delta / 4;
            end
        end

        x0 = x1;
        f0 = f1;

    end

    x = x0;
    y = f0;
    N = i + 1;

end
