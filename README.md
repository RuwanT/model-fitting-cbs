# model-fitting-cbs
Effective Sampling: Fast Segmentation Using Robust Geometric Model Fitting


## Running the code

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

    @article{tennakoon2017,
        Author = {Tennakoon, Ruwan and Sadri, Alireza and Hoseinnezhad, Reza and Bab-Hadiashar, Alireza},
        Journal = {arXiv preprint arXiv:1705.09437},
        Title = {Effective Sampling: Fast Segmentation Using Robust Geometric Model Fitting},
        Year = {2017}
    }