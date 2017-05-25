function [theta_f, sigma_f, Cinl, ht,  f_inx] = FLKOSfitArbitraryModel(x, k, model_type,Threshold,W)
% INPUTS
%x = data - D x N matrix of data; D - dimention of data ; N - Number of data points
%k - The size of the minimum acceptible structure in application
%model_type - type of model to fit
    %'line2D', 'plane3D', 'homography', 'fundamental', 'subspace'
%Threshold = For dicotomizing inliers ffrom outliers: 
    %T = 2~3.0 assuming normally distribured noise;

% OUTPUTS
%theta_f - final set of paramers after one FLKOS iteration
%sigma_f - final sigma
%Cinl - indexes of the inlier to theta_f 
%ht - the residuals with respect to theta_f
%f_inx - the sample that produced theta_f


[ fitfn, resfn, degenfn, psize, numpar ] = getModelParam(model_type);

[~,n] = size(x);
n_rand_inits = 1; %number of random initializations
n_iterations = 50; %number of flkos iterations

BestJ = 1e7;

init_counter = 0;
while(init_counter < n_rand_inits)
    
    %initlialize from a random psize-tupple
    [psub,pinx] = datasample(x,psize,2, 'Replace', false, 'Weights', W);
%     pinx = randsample(n,psize);
%     psub = x(:,pinx);
    
    iter_counter = 0;
    while( (iter_counter < n_iterations)  )
        theta = feval(fitfn,psub);  % Fit the model on the p-subset
        
        dist = feval(resfn,theta,x);% Compute residuals.
        
        [SRes,I] = sort(dist);
        pinx = I( (k-psize+1):k ); % Get new tupple around kth sorted residual
        psub = x(:,pinx);
        Jnew = sum( SRes( (k-psize+1):k ) ); % cost func - sum of p residuals(squared) around K

        if (Jnew < BestJ) % store the best value
            BestJ = Jnew;
            theta_f = theta;
            f_inx = pinx;
        end

        
        
        if (iter_counter ==0)
            old_pinx1 = pinx;
            old_pinx = pinx;
        end
        dist = feval(resfn,theta,x(:,old_pinx));
        dist = mean(dist);

        dist1 = feval(resfn,theta,x(:,old_pinx1));
        dist1 = mean(dist1);
        
        sd = SRes(k);%the kth residual with respect to current theta
        
        %stopping criterion
        %check if the tupples in last two interations are still within the 
        %k residuals
        if ( ( dist < sd ) && ( dist1 < sd )  &&  (iter_counter > 10))
             break;
        end
        old_pinx1 = old_pinx;
        old_pinx = pinx;
   
        iter_counter = iter_counter+1;
    end
%     if (Jnew < BestJ) % store the best value
%             BestJ = Jnew;
%             theta_f = theta;
%             f_inx = pinx;
%         end
    init_counter = init_counter+1;
end

%get the best theta and refine it
ht = feval(resfn,theta_f,x);
[sresd2,sindx]=sort(ht);
[Cinl,sigma_f]  = getInliers(sresd2,sindx,k,Threshold);
% [ sigma_f, Cinl ] = Fast_AVG_MSSE( ht, Threshold, 100, 0, 2 );
%get the inliers based on refined theta
% psub = x(:,Cinl);  
% theta_f = feval(fitfn,psub); 
% ht = feval(resfn,theta_f,x);
% [sresd2,sindx]=sort(ht);
% [Cinl, sigma_f] = getInliers(sresd2,sindx,k,Threshold);
% psub = x(:,Cinl);  
% theta_f = feval(fitfn,psub); 
end
