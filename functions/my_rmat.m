function R = my_rmat(angs)
% Rotation matrix with Euler parametrization:
% R = Rz(phi)*Ry(theta)*Rz(gamma)

% Syntax:
% R = my_rmat(angs)
% angs = [gamma, theta, phi]
% gamma = optical axis rotation
% theta = polar angle
% phi = azimuth angle

g = angs(1);
t = angs(2);
p = angs(3);

R1 = [cos(g), -sin(g), 0
      sin(g),  cos(g), 0
       0,        0,    1];

R2 = [cos(t), 0, sin(t)
          0,  1,    0
      -sin(t),  0, cos(t)];


R3 = [cos(p) -sin(p) 0
     sin(p)  cos(p)  0
       0       0     1];

R = R3*R2*R1