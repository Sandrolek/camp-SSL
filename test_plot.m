function [] = test_plot()
    hold on;

    x1 = -10:0.4:10;
    y1 = x1 * 2 + 4;
    a = [1, 2];
    v = [1, 2];

    plot(x1, y1);

    x2 = -10:0.4:10;
    y2 = x2 * (-1) - 5;
    b = [1, -1];
    u = [1, -1];

    plot(x2, y2);

    disp(inter_lines(a, v, b, u));

hold off;
end