## Pipeline to convert raw accelerometer files to Actigraph count files

### 1. rawacc_to_GGIRcounts.R

Uses GGIR to read raw accelerometer data, applies activityCounts package to estimate counts, and then stores the counts in the GGIR output.

### 2. GGIRcoutns_to_Actigraphcsv.R

Create imitated Actigraph file based on Count values that were derived with previous step.
This will be the input for the PALMS app.
