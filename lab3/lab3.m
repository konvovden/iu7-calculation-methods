function lab3()
    clc();
    warning('off', 'all');

    debug = 1;
    delaySeconds = 3.0;

    a = 0;
    b = 1;
    e = 1e-6;

    fplot(@f, [a, b]);
    hold on;
    

    [x, y, N] = parabolicMethod(a, b, e, debug, delaySeconds);
   
    fprintf('RESULT: e = %f | N = %d | x* = %.10f | f(x*) = %.10f', e, N, x, y)

    scatter(x, y, 'g', 'filled');
    
    hold off;
end

function y = f(x)
    y = sin((power(x, 4) + power(x, 3) - 3 * x + 3 - power(30, 1/3)) / 2) + tanh((4 * sqrt(3) * power(x, 3) - 2 * x - 6 * sqrt(2) + 1) / (-2 * sqrt(3) * power(x, 3) + x + 3 * sqrt(2))) + 1.2;
end

function [x, y, N] = parabolicMethod(a, b, e, debug, delaySeconds)
    [x1, f1, x2, f2, x3, f3, N] = findStartPointsByGoldenRation(a, b, e, debug, delaySeconds);

    fprintf("Found start points: x1 = %.10f (%.10f) | x2 = %.10f (%.10f) | x3 = %.10f (%.10f)\n", x1, f1, x2, f2, x3, f3);

    fprintf("Finding minimum via parabolic method...\n");

    i = 0;

    while 1
        hold off;
        fplot(@f, [a, b]);
        hold on;

        i = i + 1;

        a0 = f1;
        a1 = (f2 - f1)/(x2 - x1);
        a2 = ((f3 - f1)/(x3 - x1) - (f2 - f1)/(x2 - x1))/(x3 - x2);
    
        q = parabola_function(a0, a1, a2, x1, x2);

        if i ~= 1
            old_x_tilt = x_tilt;
        end

        x_tilt = (x1 + x2 - a1/a2)/2;
        f_tilt = f(x_tilt);

        if debug

            fprintf("%i. x1 = %.10f | x2 = %.10f | x3 = %.10f | x_tilt = %.10f\n", i, x1, x2, x3, x_tilt);

            fplot(q, [a, b], 'LineStyle', ':', 'Color', 'r');
            scatter(x1, f1, 'r');
            scatter(x2, f2, 'r');
            scatter(x3, f3, 'r');
            scatter(x_tilt, f_tilt, 'r', 'filled');
            pause(delaySeconds);
            fplot(q, [a, b], 'LineStyle', ':', 'Color', 'b');
            scatter(x1, f1, 'b');
            scatter(x2, f2, 'b');
            scatter(x3, f3, 'b');
            scatter(x_tilt, f_tilt, 'b', 'filled');
        end

        if x2 < x_tilt
            if f2 <= f_tilt
                x3 = x_tilt;
                f3 = f_tilt;
            else % f2 > f_tilt
                x1 = x2;
                f1 = f2;
                x2 = x_tilt;
                f2 = f_tilt;
            end
        else % x2 > x_tilt
            if f_tilt <= x2
                x3 = x2;
                f3 = f2;
                x2 = x_tilt;
                f2 = f_tilt;
            else % f_tilt > x2
                x1 = x_tilt;
                f1 = f_tilt;
            end
        end

        if i ~= 1
            if abs(x_tilt - old_x_tilt) <= e
                break;
            end
        end
    end

    x = x_tilt;
    y = f_tilt;
    N = N + i;
end

function [result_x1, result_f1, result_x2, result_f2, result_x3, result_f3, N] = findStartPointsByGoldenRation(a, b, e, debug, delaySeconds)
    t = (sqrt(5) - 1) / 2;
    l = b - a;

    x1 = b - t * l;
    f1 = f(x1);
    x2 = a + t * l;
    f2 = f(x2);

    fprintf("Finding start points via golden ratio method...\n")

    i = 1;

    if debug 
        fprintf('%i: a%i = %.10f | b%i = %.10f\n', i, i, a, i, b);
        line([a, b], [f(a), f(b)], 'Color', 'red', 'LineStyle', '--');
        pause(delaySeconds);
        line([a, b], [f(a), f(b)], 'Color', 'blue', 'LineStyle', '--');
    end

    while 1
        if l > 2 * e
            i = i + 1;


           if f1 <= f2
                b = x2;
                l = b - a;

                new_x = b - t * l;
                new_f = f(new_x);

                if debug 
                    fprintf('%i: a%i = %.10f | b%i = %.10f\n', i, i, a, i, b);
                    line([a, b], [f(a), f(b)], 'Color', 'red', 'LineStyle', '--');
                    pause(delaySeconds);
                    line([a, b], [f(a), f(b)], 'Color', 'blue', 'LineStyle', '--');
                end

                if new_f > f1
                    break;
                end

                x2 = x1;
                f2 = f1;

                x1 = new_x;
                f1 = new_f;
            else % f1 > f2
                a = x1;
                l = b - a;
                
                new_x = a + t * l;
                new_f = f(new_x);

                if debug         
                    fprintf('%i: a%i = %.10f | b%i = %.10f\n', i, i, a, i, b);
                    line([a, b], [f(a), f(b)], 'Color', 'red', 'LineStyle', '--');
                    pause(delaySeconds);
                    line([a, b], [f(a), f(b)], 'Color', 'blue', 'LineStyle', '--');
                end

                if new_f > f2
                    break;
                end
                
                x1 = x2;
                f1 = f2;
                
                x2 = new_x;
                f2 = new_f;
           end

        else
            break
        end
    end

    result_x1 = x1;
    result_f1 = f1;

    result_x2 = x2;
    result_f2 = f2;

    result_x3 = new_x;
    result_f3 = new_f;

    N = i + 1;
end

function q = parabola_function(a0, a1, a2, x1, x2)
    q = @(x) ((a0 + a1*(x - x1) + a2 * (x - x1)*(x - x2)));
end