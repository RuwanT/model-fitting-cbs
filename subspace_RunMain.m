clear all
close all
clc

rng(22)
warning off

addpath('./model_specific');
addpath('./data');
addpath('./utils');

DATA_ROOT = 'C:\Work\RMIT_WORK\HMSS_SpectralClustering\data\Hopkins155\';

results = zeros(25,6);
for seq_num=1:25
    disp(['running sequence ', num2str(seq_num)]);
    group = '_g23';
    numModels = 1;

    %Get data
    load('./data/HopkkingChekerLables.mat') ;
    label = cell2mat(HopkingsLables(seq_num));
    currnt_dir = pwd;
    cd_path = [DATA_ROOT label];
    cd(cd_path);
    Image = imread('preview.jpg');

    c_case = [label group];
    cd_path = [DATA_ROOT c_case];
    cd(currnt_dir);
    cd(cd_path);

    file_nm = [c_case '_truth.mat'];
    load(file_nm);
    cd(currnt_dir);


    generate_test_data
    WW = reshape(permute(xord(1:2,:,:),[1 3 2]),2*frames,points);
    
    data = WW;
    label = [];

    for (i=1:ngroups)
        label = [label i*ones(1,Ng(i))];
    end
    numModels = ngroups-1;

    % Number of structures.
    numm = max(label);

    %Parameter Declaration
    k=40;%floor(length(label)/10);
    model_type = 'Subspace';
    Threshold =3.0;

    SampFrac_min = 1/numm;
    numHypo = 100; %number of hypothesis to be generated for clustering

    X = data;

    numRuns = 100;
    miss_rateH = zeros(1,numRuns);
    ttimeH = zeros(1,numRuns);
    for nRuns=1:numRuns
        [ClustLabels,ttime] = subspace_Run(X, label, k, numModels, model_type, Threshold, SampFrac_min, numHypo );
        ClustLabels = runRefinement(X, ClustLabels, numModels+1, model_type);

        %Permute data labels to match the originals.
        [miss_rate,index] = missclass(ClustLabels,label);
        new_elabel = zeros(size(ClustLabels));
        for i=1:max(ClustLabels)
            new_elabel(ClustLabels == index(i)) = i;
        end
        ClustLabels = new_elabel;

        miss_rateH(nRuns) = miss_rate;
        ttimeH(nRuns) = ttime;
    end

    disp(['Seg error = (mean, median)', num2str(mean(miss_rateH)), ', ' , num2str(median(miss_rateH))])
    disp(['Seg Time = (mean, median)', num2str(mean(ttimeH)), ', ' , num2str(median(ttimeH))])

    results(seq_num,:) = [mean(miss_rateH), median(miss_rateH),min(miss_rateH), mean(ttimeH), median(ttimeH), min(ttimeH)];

end
