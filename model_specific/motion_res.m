function [dist] = motion_res(P, X)
s = sqrt(length(P));
P = reshape(P,s,s);
dist = sum((P*X).^2)';

M = P(:);


end