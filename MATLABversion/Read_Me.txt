{\rtf1\ansi\ansicpg1252\cocoartf1504\cocoasubrtf830
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 Data files:\
\
signaturesBarcodesZeroDim - Contains barcodes (or persistence diagrams) for all handwritten signatures in the database, with persistent homology computed with mod 2 coefficients, in dimension zero. After loading the file, each individual barcode can be called as\
\
signaturesBarcodesZeroDim\{j,k\}\
\
The j coordinate corresponds to signature example and k corresponds to the particular instance. The k=1 through 20 are genuine signatures and k=21 through 40 are forgeries. There are 40 total signature classes (so j ranges from 1 through 40).\
\
signaturesBarcodesOneDim - Same as above, the homology is in dimension one.\
\
planarShapesBarcodesZeroDim - Contains barcodes (or persistence diagrams) for all planar shapes in the database, with persistent homology computed with mod 2 coefficients, in dimension zero. After loading the file, each individual barcode can be called as\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
planarShapesBarcodesZeroDim\{j\}\
\
where j runs from 1 through 1300. There are 65 shape categories, with 20 example shapes from each category. The categories run sequentially (so j=1 through 20 are all \'93bone\'94 shapes, etc.).\
\
planarShapesBarcodesOneDim - Same as above, the homology is in dimension one.}