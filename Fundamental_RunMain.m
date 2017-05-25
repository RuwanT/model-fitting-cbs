
rng(22)
addpath('./model_specific');
addpath('./data');
addpath('./utils');


load('fundLabel');

results = zeros(9,2);
for seq_num =1:9
    disp(['running seq: ', cell2mat(fundLabel(seq_num))])
    load(cell2mat(fundLabel(seq_num)));
    numModels=max(label) - min(label);
    
    numPoints=[];
    for i=min(label):max(label)
        numPoints = [ numPoints , sum(label==i)];
    end
    disp(['Num Points(outliersFirst): ', num2str(numPoints)])
    N = sum(numPoints);
    
    %Parameter Declaration
    k=floor(min(0.1*N, 20));
    model_type = 'fundamental';
    Threshold = 3.5;
    SampFrac_min = 1/numModels;
    numHypo = 100; %number of hypothesis to be generated for clustering


    %remove repeating rows in data
    [data,ia,ic] = unique(data','rows');
    data = data';
    label = label(ia);

    dat_img_1 = normalise2dpts(data(1:3,:));
    dat_img_2 = normalise2dpts(data(4:6,:));

    X = [dat_img_1;dat_img_2];

    numRun = 100;
    miss_rateH = zeros(1,numRun);
    ttimeH = zeros(1,numRun);
    for nRun=1:numRun
        [ClustLabels,ttime] = Fundamental_Run(X, k, numModels, model_type, Threshold, SampFrac_min, numHypo);
        ClustLabels = ClustLabels-1;
        
        %Permute data labels to match the originals.
        [miss_rate,index] = missclass(ClustLabels,label);
        new_elabel = zeros(size(ClustLabels));
        for i=1:max(ClustLabels)
            new_elabel(ClustLabels == index(i+1)) = i;
        end
        ClustLabels = new_elabel;
    
        miss_rateH(nRun) = miss_rate;
        ttimeH(nRun) = ttime;
        disp(['misclass error = ', num2str((miss_rate))])
    end


    results(seq_num,:) = [median(miss_rateH), median(ttimeH)];
end

