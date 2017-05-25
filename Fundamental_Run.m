function [ClustLabels,ttime] = Fundamental_Run(X, k, numModels, model_type, Threshold, SampFrac_min, numHypo)

%INPUTS
%X - Input Data [d,N]
%k - paprameter kth 
%numModels - number of models to recover
%model_type - model type - line2D, fundamental, homography ....
%Threshold - MSSE theshold T
%SampFrac_min - sample fraction to be included in bootstrap
%numHypo - number of hypothesis to be generated

%OUTPUTS
%ClustLabels - estimated labels (not corrected with original
%ttime - time to run the algorithm 


SampFrac = SampFrac_min; %fraction of data to be included in a sample
USE_GRAOUSE =0;

[ fitfn, resfn, degenfn, psize, numpar ] = getModelParam(model_type);

N = size(X, 2);
W = ones(1,N); %weights for bootstrap sampling

H = zeros(N,numHypo); %container for holding affinities to models
sdevHold = zeros(1,numHypo); %container for holding std to models

sigma_o = 0;
hypo_count=1;
tic;
Converged = 0;
while (Converged==0)
    %sample a dataset according to weights 
    [Xs,Is] = datasample(X, floor(SampFrac*N), 2, 'Replace', false, 'Weights', W);
    Ws = W(Is);
    
    %run HMSS on selcted data sample
    [theta_f, sigma_f, ~ , ~,  ~] = FLKOSfitArbitraryModel(Xs, k, model_type,Threshold, Ws);
    
    %do MCMC rejection
    %{
    u = rand(1);
    p = min(1, exp( -(sigma_f-sigma_o)) );
    sigma_o = sigma_f;
    if(u>p && hypo_count ~= 0)
       continue; 
    end
    %}
    
    %get the residual for all data points
    ht=feval(resfn, theta_f, X);  
   
    %calculate the inliers and outlier (all data points are used here)
    Cinl = ht< (Threshold^2) * (sigma_f^2);
    Coutl = ~Cinl;
    
    H(:,hypo_count) = exp(-ht/( 2*(sigma_f^2) ) );
    sdevHold(hypo_count) = sigma_f;

    %update the bootstraping weights
    W(Cinl) = W(Cinl)/2;
    W(Coutl) = W(Coutl)*2;
    W(W<.1) = .1;
    W(W>20) = 1;
    
    
    if hypo_count==numHypo
        Converged = 1;
    end
    
    
    hypo_count = hypo_count+1;
end


G = H*H';
[~, ClustLabels] = spectralClustering_ALI(G, numModels);

ttime = toc;







