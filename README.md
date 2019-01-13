# model-fitting-cbs
Effective Sampling: Fast Segmentation Using Robust Geometric Model Fitting

### Abstract
``Identifying the underlying models in a set of data points that is contaminated by noise and outliers leads to a highly complex multi-model fitting problem. This problem can be posed as a clustering problem by the projection of higher-order affinities between data points into a graph, which can be clustered using spectral clustering. Calculating all possible higher-order affinities is computationally expensive. Hence, in most cases, only a subset is used.\\
Here, we propose an effective sampling method for obtaining a highly accurate approximation of the full graph, which is required to solve multi-structural model fitting problems in computer vision. The proposed method is based on the observation that the usefulness of a graph for segmentation improves as the distribution of the hypotheses that are used to build the graph approaches the distribution of the actual parameters for the given data. In this paper, we approximate this actual parameter distribution by using a $k$th-order statistics-based cost function, and the samples are generated using a greedy algorithm that is coupled with a data sub-sampling strategy. 
The experimental analysis shows that the proposed method is both accurate and computationally efficient compared to the state-of-the-art robust multi-model fitting techniques.``

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
