function lab4_1()

    [x, y] = fminbnd(@f, 0, 1, optimset('Display', 'iter', 'TolX', 10e-7));

    fprintf('RESULT: x* = %.10f | f(x*) = %.10f', x, y)
end

function y = f(x)
    y = sin((power(x, 4) + power(x, 3) - 3 * x + 3 - power(30, 1/3)) / 2) + tanh((4 * sqrt(3) * power(x, 3) - 2 * x - 6 * sqrt(2) + 1) / (-2 * sqrt(3) * power(x, 3) + x + 3 * sqrt(2))) + 1.2;
end