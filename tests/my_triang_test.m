clear; clc
% Proponemos los puntos en el espacio.
t1 = [1; 1; 1];
t2 = [3; -4; 5];
p = [1 -4
     2 5
     3 -10];
d1 = (p - t1)/2;
d2 = (p - t2)/3;

p_test = my_triang(t1, t2, d1, d2)
