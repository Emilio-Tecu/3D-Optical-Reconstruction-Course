clear; clc

% Testing the function my_hom

s = pi;

c = [ 2   7  -1   8    1    % x-coordinate
      5   9   3   4   -1];  % y-coordinate

% Plotting points (in Cartesian coordinates)
k = 1;
subplot(1,2,1)
plot( [0, c(1,k)], [0, c(2,k)], '-o'); grid on
hold on
    text( c(1,k)+0.1, c(2,k)+0.1, num2str(k) )
    for k = 2:size(c,2)
        plot( [0, c(1,k)], [0, c(2,k)], '-o' );
        text( c(1,k)+0.1, c(2,k)+0.1, num2str(k) )
    end
hold off
xlabel('X-axis');
ylabel('Y-axis');
title('Cartesian Coordinates');

lambda = 2;
h = lambda * my_hom( c, s );


subplot(1,2,2)
plot3( [0, h(1,k)], [0, h(2,k)], [0, h(3,k)], '-o'); grid on
hold on
text( h(1,k)+0.1, h(2,k)+0.1, h(3,k)+0.1, num2str(k) )
for k = 2:size(c,2)
    plot3( [0, h(1,k)], [0, h(2,k)], [0, h(3,k)], '-o' );
    text( h(1,k)+0.1, h(2,k)+0.1, h(3,k)+0.1, num2str(k) )
end
[X,Y,Z] = meshgrid( [-1,8], [-1,9], s );
surf( X, Y, Z ); alpha(0.6)
hold off
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
title('Homogeneous Coordinates');

% Recuperar coordenadas cartesianas dadas sus coordenadas homogeneas

c_rec = my_ihom( h, s );

disp('Initial Cartesian Coordinates = '); disp(c)
disp('Homogeneous Coordinates = '); disp(h)
disp('Recovered Cartesian Coordinates = '); disp(c_rec)
