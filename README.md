# model-fitting-cbs
Effective Sampling: Fast Segmentation Using Robust Geometric Model Fitting


## Running the code
The code requires VLFeat installed in MATLAB: `http://www.vlfeat.org/install-matlab.html`

### Two-view motion segmentation
* Download the [AdelaideRMF dataset](https://cs.adelaide.edu.au/users/hwong/doku.php?id=data) into `./data` folder 
* Run the script `Fundamental_RunMain.m`
* The results (median accuaracy, median computing time) for each imag-pair will be writen to matlab variable 'results'


### 3D-motion segmentation of rigid bodies
* Download [Hopkings dataset](http://vision.jhu.edu/data/) into `./data` folder
* Set the `group` variable in `subspace_RunMain.m` to `group = '' or '_g12' or '_g13' or '_g23'`
* Point `DATA_ROOT` variable in `subspace_RunMain.m` to the dataset location
* Run the script `subspace_RunMain.m`
* The results (median accuaracy, median computing time) for each sequence will be writen to matlab variable 'results'


## Publication

If you find this work useful in your research, please consider citing:

    @article{tennakoon2018effective,
    title={Effective sampling: Fast segmentation using robust geometric model fitting},
    author={Tennakoon, Ruwan and Sadri, Alireza and Hoseinnezhad, Reza and Bab-Hadiashar, Alireza},
    journal={IEEE Transactions on Image Processing},
    volume={27},
    number={9},
    pages={4182--4194},
    year={2018},
    publisher={IEEE}
    }
