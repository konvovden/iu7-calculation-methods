function lab2()
    clc();

    debug = 1;
    delaySeconds = 1.0;

    a = 0;
    b = 1;
    e = 0.01;

    fplot(@f, [a, b]);
    hold on;
    

    [x, y, N] = goldenRatio(a, b, e, debug, delaySeconds);
   
    fprintf('RESULT: e = %f | N = %d | x* = %.10f | f(x*) = %.10f', e, N, x, y)

    scatter(x, y, 'g', 'filled');
    
    hold off;
end

function y = f(x)
    y = sin((power(x, 4) + power(x, 3) - 3 * x + 3 - power(30, 1/3)) / 2) + tanh((4 * sqrt(3) * power(x, 3) - 2 * x - 6 * sqrt(2) + 1) / (-2 * sqrt(3) * power(x, 3) + x + 3 * sqrt(2))) + 1.2;
end

function [x, y, N] = goldenRatio(a, b, e, debug, delaySeconds)
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

                x2 = x1;
                f2 = f1;

                x1 = b - t * l;
                f1 = f(x1);
            else
                a = x1;
                l = b - a;
                
                x1 = x2;
                f1 = f2;
                
                x2 = a + t * l;
                f2 = f(x2);
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

    if debug 
        line([a, b], [f(a), f(b)], 'Color', 'blue', 'LineStyle', '--');
    end

    x = (a + b) / 2;
    y = f(x);

    N = i + 1;

end
