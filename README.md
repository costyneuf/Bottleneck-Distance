# Bottleneck Calculator

This project implements a simplified version of bottleneck distance for persistence diagrams. Users can choose given data sets for test, or 
upload customized data sets for analysis.  

### Programming Language

Javascript

### Current Limitations

Javascript does not support large data sets. (i.e., in section 3.1, data sets PD4 and PD5 cannot be tested)

The limitation is caused by the large time complexity of the recursion algorithm for calculating determinants.
As tested, the optimal cardinality after calling equalCard(A, C) should be less than 11.