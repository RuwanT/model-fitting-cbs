function [ClustLabels,ttime, ClustLabels_SC] = subspace_Run(X, label, k, numModels, model_type, Threshold, SampFrac_min, numHypo)

[ fitfn, resfn, degenfn, psize, numpar ] = getModelParam(model_type);


SampFrac = SampFrac_min; %fraction of data to be included in a sample
USE_GRAOUSE = 0;

%X = data;%[dat_img_1;dat_img_2]; % dxN matrix of data
N = size(X, 2);
W = ones(1,N)*2; %weights for bootstrap sampling



H = zeros(N,numHypo); %container for holding affinities to models
sdevHold = zeros(1,numHypo);

sigma_o=0;
hypo_count=1;
tic;

Converged = 0;
while(Converged==0)

    [Xs,Is] = datasample(X, floor(SampFrac*N), 2, 'Replace', false, 'Weights', W);
    Ws = W(Is);
    %run HMSS on selcted sample
    [theta_f, sigma_f, ~ , ~,  ~] = FLKOSfitArbitraryModel(Xs, k, model_type,Threshold, Ws);
    
    %get the residual for all data points
    ht=feval(resfn, theta_f, X);  
    
    %do MCMC rejection
    %{
    u = rand(1);
    p = min(1, exp( -(sigma_f-sigma_o) ) );
    sigma_o = sigma_f;
    if(u>p && hypo_count ~= 0)
       continue; 
    end
    
    %}
    
    H(:,hypo_count) = exp(-ht/( 2*(sigma_f^2) ) );
    sdevHold(hypo_count) = sigma_f;
    Cinl = ht< (Threshold^2) * (sigma_f^2);
    Coutl = ~Cinl;
    
    %update the bootstraping weights
    W(Cinl) = W(Cinl)/2;
    W(Coutl) = W(Coutl)*2;
    W(W<.1) = .1;
    W(W>20) = 1;
%     SampFrac = SampFrac*.75;
%     if(SampFrac<SampFrac_min)
%        SampFrac = SampFrac_min; 
%     end
    
    
    if (USE_GRAOUSE ==0)
        % Const Iter Stopping Crit %
        if hypo_count==numHypo
            Converged = 1;
        end
        
    else

        % Grassmannian Manifold Stopping %
        if hypo_count==3
            Grass_Thrsh = 0.01;
            step_size = .05;
            U = orth(H(:,1:3));
            step_rec(1:hypo_count) = 10*Grass_Thrsh;
        end    
        if hypo_count>3
            v_Omega = H(:,hypo_count);
            U_Omega = U;    
            weights = U_Omega\v_Omega;
            norm_weights = norm(weights);
            residual = v_Omega - U_Omega*weights;       
            norm_residual = norm(residual);
            sG = norm_residual*norm_weights;
            t = step_size*sG/hypo_count;
            alpha = (cos(t)-1)/norm_weights^2;
            beta = sin(t)/sG;
            step = U*(alpha*weights);
            step = step + beta*residual;
            Udiff = step*weights';
            U = U + Udiff;
            ChangeinU = max(sum(Udiff.^2).^0.5);
            step_rec(hypo_count)=ChangeinU;
            if max(step_rec(end-3:end))<Grass_Thrsh || hypo_count==numHypo
% %                 disp(['Num Hypo at stop: ',num2str(hypo_count)])
                Converged = 1;
            end
        end
    end
    hypo_count = hypo_count+ 1;
end

if (USE_GRAOUSE ==0)
    G = H*H';
    [~, ClustLabels] = spectralClustering_ALI(G, numModels);
%      ClustLabels = SpectralClustering(G,numModels);
else
    G = H*H';
    [~, ClustLabels] = spectralClustering_ALI(G, numModels);
%     [~, ClustLabels, ~] = vl_kmeans(U', numModels+1, 'distance', 'l1', ...
%          'algorithm', 'elkan', 'NumRepetitions', 100, 'NumTrees', 3); 
%     ClustLabels = double(ClustLabels');
end


ttime = toc;