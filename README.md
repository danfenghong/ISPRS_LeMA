# Learnable Manifold Alignment (LeMA): A Semi-supervised Cross-modality Learning Framework for Land Cover and Land Use Classification

Danfeng Hong, Naoto Yokoya, Nan Ge, Jocelyn Chanussot, Xiaoxiang Zhu
---------------------

![alt text](./workflow_R.jpg)

The code in this toolbox implements the ["Learnable Manifold Alignment (LeMA): A Semi-supervised Cross-modality Learning Framework for Land Cover and Land Use Classification"](https://www.sciencedirect.com/science/article/pii/S0924271618302843).
More specifically, it is detailed as follow.

Citation
---------------------

**Please kindly cite the papers if this code is useful and helpful for your research.**

     @article{hong2019learnable,
      title={Learnable Manifold Alignment ({L}e{MA}): A Semi-supervised Cross-modality Learning Framework for Land Cover and Land Use Classification},
      author={D. Hong and N. Yokoya and N. Ge and J. Chanussot and X. Zhu},
      journal={ISPRS J. Photogramm. Remote Sens.},
      volume={147},
      pages={193--205},
      year={2019},
      publisher={Elsevier}
     }


System-specific notes
---------------------
The code was tested in Matlab R2016a or higher versions on Windows 10 machines.

How to use it?
---------------------

Directly run demo.m to reproduce the results on the Houston2013  data, which exists in the aforementioned paper.  
please note that we fix some uncertainities in this code using "rng" funciton, such as during the clustering and CCF classifier,
therefore, the reproduced results are lightly different with those in this paper.  
Note that the hyperspectral and simulated multispectral Houston2013 data can be downloaded from  
[google drive](https://drive.google.com/open?id=1Inpi2_lHuvEWdJX_Duj9ild1_a0LHKmD)  
[baiduyun](https://pan.baidu.com/s/1ABbWgkEkzp2Q02yjeYjxvw): ivb0 (access code).

If you want to run the code in your own data, you can accordingly change the input (e.g., data, labels) and tune the parameters.

If you encounter the bugs while using this code, please do not hesitate to contact us.


Acknowledgment
---------------------

We would like to thank Prof. Deng Cai, Dr. Tom Rainforth, and Prof. Chih-Chung Chang and Prof. Chih-Jen Lin for providing the Matlab Codes of LPP, CCF, and SVM, respectively. 
Codes for these algorithms used in our paper can be found in the following.

LPP: the code is available in http://www.cad.zju.edu.cn/home/dengcai/.

CCF: the code is available in https://github.com/jandob/ccf.

SVM: the code is available in https://www.csie.ntu.edu.tw/~cjlin/libsvm/oldfiles/index-1.0.html.

If you want to use the codes mentioned above, please cite the corresponding articles as well.

For the datasets used in our paper (Houston data and Chikusei data), you can  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;apply for the Univeristy of Houston hyperspectral dataset from [IEEE GRSS Data Fusion Contest 2013](http://www.grss-ieee.org/community/technical-committees/data-fusion/2013-ieee-grss-data-fusion-contest/);  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;download the Chikusei data from http://naotoyokoya.com/Download.html.

Or please feel free to contact me if you are interested in such tasks.

Licensing
---------

Copyright (C) 2019 Danfeng Hong

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.

Contact Information:
--------------------

Danfeng Hong: hongdanfeng1989@gmail.com<br>
Danfeng Hong is with the Remote Sensing Technology Institute (IMF), German Aerospace Center (DLR), Germany; <br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; with the Singnal Processing in Earth Oberservation (SiPEO), Technical University of Munich (TUM), Germany. 
