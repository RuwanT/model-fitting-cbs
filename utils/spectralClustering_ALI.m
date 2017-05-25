function [W, ClustLabels] = spectralClustering_ALI(W, numModels)

%         W = W ./ ( repmat( diag(W), 1, length(diag(W))) .* repmat( diag(W)',  length(diag(W)), 1 ) );
        W = W/max(W(:)+eps); % may remove eps
%         ind = (sum(W)< 1e-3); %1e-3
%         W(ind,ind)=max(W(:));


%         figure
%         plot(sum(W),'.')
        
% %         W = W ./ ( repmat( diag(W), 1, length(diag(W))) .* repmat( diag(W)',  length(diag(W)), 1 ) );
% W = W ./ ( repmat( diag(W).^.5, 1, length(diag(W))) .* repmat( (diag(W)').^.5,  length(diag(W)), 1 ) );

%         D = diag(1./sum(W).^0.5);
%         L = D*W*D;
%         [V,S,~]=svd(L);
%         to_rem = sum(diag(S)>.99);
%         V = V(:,to_rem+1: to_rem+numModels);

        %old
        D = diag(1./(sum(W)+eps).^0.5); %may remove eps
        L = D*W*D;
        [V,~,~]=svd(L);
        V = V(:,1: numModels+1);
        
        
        
%         DN = diag( 1./sqrt(sum(CKSym)+eps) );
%         LapN = speye(N) - DN * CKSym * DN;
%         [uN,sN,vN] = svd(LapN);
%         kerN = vN(:,N-n+1:N);
%         for i = 1:N
%             kerNS(i,:) = kerN(i,:) ./ norm(kerN(i,:)+eps);
%         end
        
        
        
%         
%         V = bsxfun(@rdivide, V, sqrt(sum(V.^2, 2)));
        [~, ClustLabels, ~] = vl_kmeans(V', numModels+1, 'distance', 'l1', ...
             'algorithm', 'elkan', 'NumRepetitions', 100, 'NumTrees', 3); 
        ClustLabels = double(ClustLabels');

        %what does num trees do