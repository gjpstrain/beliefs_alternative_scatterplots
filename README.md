# Effects of Alternative Scatterplots Designs on Belief

Files, data, and scripts required to fully recreate our study investigating how alternative scatterplot designs can induce greater levels of belief change compared to standard scatterplots.

## Data

All data (.csv format) is located in the `data` folder. This includes data from previously published work required to create Figure 1, pre-test and main test stimuli, and the raw response data for each.

## Scripts

The `additional_scripts` folder contains scripts for processing responses from pavlovia.org; it writes a .csv with a list of passed and failed participants to the `data` folder when run. This folder also contains an .rmd file to create the supplementary materials .pdf, and the script to anonymise data following processing for payment.

NB: Aside from anonymisation, data are provided *as-is*. The **wrangle** function *must* be run to make the dataset usable.

### Analysis Within a Fully-Reproducible Computational Environment

Resources are provided for the full reproduction of the computational environment (R, Rstudio, and package versions) that was used for data wrangling, visualization, statistical modelling, and reporting.

To begin, clone this repository to your local machine. With Docker running in the background, use a terminal (or cmd on Windows) to navigate to the cloned repository and type the following Docker command:

```docker build -t atypical_scatterplots .```

If you're using a machine with an ARM processor, such as Apple Silicon, use the following command to build an image:

```docker buildx build --platform linux/amd64 -t atypical_scatterplots .```

Then, type:

```docker run --rm -p 8787:8787 -e PASSWORD=password atypical_scatterplots```

Once the container is running, open a web browser and type `localhost:8787` in the address bar. Enter the username `rstudio` and the password `password`. This will generate a fully functioning Rstudio session running from the docker container.

### Re-creating the manuscript

Opening `atypical_scatterplots.qmd` and using the 'Render' button will allow you to re-create a .pdf of the manuscript.

IMPORTANT: Models have been cached to increase performance. The cache will not be recognised automatically when using RStudio within the Docker container. eval_models must be set to FALSE in line 10 in order to use the cached models. This will prevent knitr from executing the code for each model, but will 'lazyload' all cached models so they can be used in manuscript generation. Setting eval_models to TRUE in line 10 will result in all models being re-generated.

The manuscript was written using the ACM CHI template. An issue with quarto/pandoc means that the tables are rendered partially outside of the pdf boundaries. I solved this by manually editing the resulting .tex file and re-running it. The source files in `placeholder` have had these changes implemented.

Files and folders used in generating manuscript:

 - `atypical_scatterplots.qmd`: Full quarto markdown script including text and all code
 - `atypical_scatterplots_cache/pdf`: folder containing cached models
 - `data`: folder containing collected, anonymized data
 - `size-opacity.bib` for referencing
 - `_extensions`: templates etc required for quarto to correctly render manuscript

Knitting the manuscript may take some time depending on the performance of your computer, especially if models are being re-built.

### Other Files

 - `item_preparation`: folder containing scripts to generate all experimental items, practice items, and visual masks
 - `additional_scripts`: folder containing other R scripts detailed above

## Experiment Code and Materials

 - Pre-test: [https://gitlab.pavlovia.org/Strain/beliefs_scatterplots_pretest](https://gitlab.pavlovia.org/Strain/beliefs_scatterplots_pretest)
 - Main Test Group A: [https://gitlab.pavlovia.org/Strain/atypical_scatterplots_main_t](https://gitlab.pavlovia.org/Strain/atypical_scatterplots_main_t)
 - Main Test Group B: [https://gitlab.pavlovia.org/Strain/atypical_scatterplots_main_a](https://gitlab.pavlovia.org/Strain/atypical_scatterplots_main_a)
 
## Pre-Registration

Pre-registrations for hypotheses with the OSF can be found here:
 - [Pre-test](https://osf.io/xuf4d)
 - [Main Test](https://osf.io/anmez)
