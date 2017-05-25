function [P] = motion_fit(X)
% 
% uX = mean(X,2);
% X1 = X - repmat(uX,1,size(X,2));
[U,s,~]=svd(X,'econ');

matrank=modelselection(diag(s),2e-6);
d=min(2,matrank);
d=max(4,d);
% d=4;
% s = diag(s);
% ind = find(s<1.0,1,'first');
% if ind >4
%     ind = 4;
% end
% d=4;
Y=U(:,1:d);
H = eye(size(X,1)) - Y*Y';
P = H(:);
end


