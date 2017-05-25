function [inliers,stdevI] = getInliers(rs,I,k,T)

    if(k> length(rs)) %if data size is smaller than k all are inliers
        inliers = I;
    else
        sig1 = cumsum(rs)./[(1:length(rs))']; %TODO change 2 - psize maybe we dont need it because i use LSF

        sig = sig1(k:end-1);
        r = rs(k+1:end);

        mask = (r>sig*T*T);

        fInd = find(mask>0,1,'first') ;

        if(isempty(fInd))
                fInd = 0;
        elseif(fInd > 0.9*length(sig))
           fInd =0;%length(rs)-k;    
        end

        fInd = fInd+k-1;
        inliers = I(1:fInd);

        stdevI = sig1(fInd)^.5;
        %sdevk = sig1(k)^.5;

    end
