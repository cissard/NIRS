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

The following scripts and functions work with the scripts from Mehler lab:
- plotTrials: sort NIRS trials manually
- PermutationsTempsEspace: runs cluster-based permutation analysis for 24 channels (requires the avg structure). Calls the following functions:
- anova_f: runs an anova on every channel-time sample and returns a logical matrix (channels x time) with the above-threshold samples
- identify_clusters: identify clusters of activity in the F matrix produced by anova_f
- anova_perm: permutes the conditions (labels) and computes the Fperm matrix (similar to F but based on permuted data).
- t_test: performs a t-test between conditions
- t_test_perm: permutes the data and runs a t_test with permuted data
