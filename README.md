# Bottleneck Calculator

This project implements a simplified version of bottleneck distance for persistence diagrams. Users can choose given data sets for test, or 
upload customized data sets for analysis.  

## Programming Language
```
MATLAB
```

### How To Open It
- Download "BottleneckDemo.zip"
- Extract "BottleneckDemo.zip"
- Open MATLAB and make "MATLABversion" the current directory
- Open "bottleneckdistance.m"
- Run

### How To Use It
- Bottleneck Distance
    - Select data from popup menu first
        - If you select "Customized Data", you should upload 2 data sets from 2 "*.mat" files
    - Click "Bottleneck Distance" button
    - Enter the value of epsilon
    - Wait for a couple of seconds to a couple of minutes until a message box with final answer appears
- Analyze Planar Shapes
    - Click "Analyze Planar Shapes" button
    - Enter two sets of data set
    - Wait for a couple of seconds to a couple of minutes until a message box with final answer appears
- Signature Test
    - Click "Sigature Test" button
    - Enter the number of data set to be examined
    - Wait for a couple of minutes until figures have been plotted
    - Check "testSignatures.txt" to see the smallest bottleneck distance between each sample and other 39 samples.

### Current Limitations
The calculation time of PD4 and PD5 is still slow but better than the Javascript version.

## Programming Language
```
Javascript
```

### Current Limitations
Javascript does not support large data sets. (i.e., in section 3.1, data sets PD4 and PD5 cannot be tested)

The limitation is caused by the large time complexity of the recursion algorithm for calculating determinants.
As tested, the optimal cardinality after calling equalCard(A, C) should be less than 11.

Due to the limitation, the UI has not been wrapped.

