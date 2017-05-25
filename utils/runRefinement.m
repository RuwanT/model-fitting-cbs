function Outlabels = runRefinement(X, Inlabels, numModels, model_type)


[ fitfn, resfn, degenfn, psize, numpar ] = getModelParam(model_type);
[n,m] = size(X);
Res = zeros(m,numModels);
for i = 1:numModels
    mask = Inlabels == i;
    if sum(mask) < 4
        Res(:,i) = inf;
        continue;
    end
    
    theta  = feval(fitfn, X(:,Inlabels == i));
    ht=feval(resfn, theta, X);
    Res(:,i) = ht;
   
   
end

[~,Outlabels] = min(Res,[],2);