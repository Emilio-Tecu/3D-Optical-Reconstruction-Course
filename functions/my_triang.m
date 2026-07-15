function p = my_triang(t1, t2, d1, d2)
% Triangulation.

% Syntax:
% p = my_triang(t1, t2, d1, d2)

% Inputs(4)
% (i1) t1 = 3x1 position of camera 1.
% (i2) t2 = 3x1 position of camera 2.
% (i3) d1 = 3xN position of camera 1.
% (i4) d2 = 3xN position of camera 2.

% Outputs(2)
% (o1) p = 3xN trianguled points.
    n = size(d1, 2);

    p = zeros(3, n);
    for k = 1:n
        A = [d1(:,k), -d2(:, k)]; % Regression matrix.

        if ~isnan(sum(A(:)))
            L = inv(A'*A)*A'*(t2-t1);
            p(:,k) = (t1 + t2 + L(1)*d1(:,k) + L(2)*d2(:,k))/2;
        end
    end

end