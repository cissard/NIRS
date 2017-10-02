# NIRS

This repository contains updated NIRS data analysis scripts. 

The following script and functions work together (written by Cécile Issard):
- AnalysisNIRS: general preprocessing pipeline calling the following functions.
- NIRS_loadNIRxdata: function that loads data files produced by a NIRx NIRScout machine.
- NIRS_baseline: define prestimulus periods that will serve as baseline values to compute I0. 
- NIRS_light2Hb: function that converts the raw intensities to Hb relative concentrations. Uses e_coef.mat.
- NIRS_defineepochs: cut the time series into epochs around each stimulus period.
- NIRS_reject: reject artefacted epochs.
- NIRS_average: average responses from non-rejected epochs.
- PlotAverageSimpleBlocks: plot the averages for each subject.

