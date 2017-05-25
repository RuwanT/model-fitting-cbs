function [ fitfn, resfn, degenfn, psize, numpar ] = getModelParam(model_type)

%---------------------------
% Model specific parameters.
%---------------------------

switch model_type

    case 'line2D'
        fitfn = @line2D_fit;
        resfn = @line2D_res;
        degenfn = @line2D_degen;
        psize = 4;
        numpar = 2;
    case 'line1D'
        fitfn = @line1D_fit;
        resfn = @line1D_res;
        degenfn = @line1D_degen;
        psize = 3;
        numpar = 1;
    case 'plane3D'
        fitfn = @plane3D_fit;
        resfn = @plane3D_res;
        degenfn = @plane3D_degen;
        psize = 5;
        numpar = 3;
    case 'homography'
        fitfn = @homography_fit;
        resfn = @homography_res;
        degenfn = @homography_degen;
        psize = 6;
        numpar = 9;
    case 'fundamental'
        fitfn = @fundamental_fit8;
        resfn = @fundamental_res;
        %resfn = @FMDistances;
        degenfn = @fundamental_degen;
        psize = 10;
        numpar = 9;
    case 'fundamental-mgs'
        fitfn = @fundamental_fit8;
        resfn = @fundamental_res;
        %resfn = @FMDistances;
        degenfn = @fundamental_degen;
        psize = 8;
        numpar = 9;
    case 'Subspace'
        fitfn = @motion_fit;
        resfn = @motion_res;
        degenfn = @motion_degen;
        psize = 6;
        numpar = 25;
    otherwise
        error('unknown model type!');
end

end