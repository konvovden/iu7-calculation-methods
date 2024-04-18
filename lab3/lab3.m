function lab2()
    clc();

    debug = 1;
    delaySeconds = 1.0;

    a = 0;
    b = 1;
    e = 0.01;

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
    [x1, x2, x3,f1, f2, f3] = findStartPointsByGoldenRation(a, b, e, debug, delaySeconds);

    a0 = f1;
    a1 = (f2) - f1/(x2 - x1);
    a2 = ((f3 - f1)/(x3 - x1) - (f2 - f1)/(x2 - x1))/(x3 - x2);

    q = parabola_function(a0, a1, a2, x1, x2, 'LineStyle', ':', 'Color', 'r');

    i = 1;

    while 1
        x_tilt = (x1 + x2 - a1/a2)/2;
        f_tilt = f(x_tilt);

        if debug
            fplot(q, [a, b]);
            scatter(x1, f1, 'r');
            scatter(x2, f2, 'r');
            scatter(x3, f3, 'r');
            scatter(x_tilt, f_tilt, 'r', 'filled');
        end        

    end

    

    x = 0;
    y = 0;
    N = 0;
end

function [result_x1, result_f1, result_x2, result_f2, result_x3, result_f3] = findStartPointsByGoldenRation(a, b, e, debug, delaySeconds)
    t = (sqrt(5) - 1) / 2;
    l = b - a;

    x1 = b - t * l;
    f1 = f(x1);
    x2 = a + t * l;
    f2 = f(x2);

    if debug 
        fprintf('0: a0 = %.10f | b0 = %.10f\n', a, b);
        line([a, b], [f(a), f(b)], 'Color', 'red', 'LineStyle', '--');
        pause(delaySeconds);
    end

    i = 1;

    while 1
        if l > 2 * e
            i = i + 1;

            if debug 
                line([a, b], [f(a), f(b)], 'Color', 'blue', 'LineStyle', '--');
            end


           if f1 <= f2
                b = x2;
                l = b - a;

                new_x = b - t * l;
                new_f = f(new_x);

                if new_f <= f1
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

                if new_f <= f2
                    break;
                end
                
                x1 = x2;
                f1 = f2;
                
                x2 = new_x;
                f2 = new_f;
           end


            if debug 
                fprintf('%d: a%d = %.10f | b%d = %.10f\n', i, i, a, i, b);
                line([a, b], [f(a), f(b)], 'Color', 'red', 'LineStyle', '--');
                pause(delaySeconds);
            end

        else
            break
        end


    end

    result_x1 = x1;
    result_f1 = f1;

    result_x2 = new_x;
    result_f2 = new_f;

    result_x3 = x2;
    result_f3 = f2;

    if debug 
        line([a, b], [f(a), f(b)], 'Color', 'blue', 'LineStyle', '--');
    end
end

function q = parabola_function(a0, a1, a2, x1, x2)
    q = @(x) ((a0 + a1*(x - x1) + a2 * (x - x1)*(x - x2)));
end