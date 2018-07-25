function P = line2D_fit(X)
%X [d,N] matrix whare d is the dimentions
%X = [x1 x2 x3 ...;
%     y1 y2 y3 ...]

x = X(1,:)';
y = X(2,:)';
n1 = length(x);

%y = ax+b
P = [x, ones(n1,1)]\y;