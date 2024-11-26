# Add the rocker/verse Docker image for R 4.4.2

FROM rocker/verse:4.4.2

# Add our files to container

ADD data/ /home/rstudio/data/
ADD additional_scripts/ /home/rstudio/additional_scripts/
ADD beliefs_alternative_scatterplots.qmd /home/rstudio/
ADD item_preparation/ /home/rstudio/item_preparation/
ADD beliefs_alternative_scatterplots_cache/ /home/rstudio/beliefs_alternative_scatterplots_cache/
ADD _extensions/ /home/rstudio/_extensions/
ADD alternative-scatterplots.bib /home/rstudio/

# Add appropriate versions of required R packages to container

RUN R -e "install.packages('devtools')"

RUN R -e "require(devtools)"

# tidyverse is included in rockerverse image

RUN R -e "devtools::install_version('MASS', version = '7.3-60.2', dependencies = T)"
RUN R -e "devtools::install_version('buildmer', version = '2.11', dependencies = T)"
RUN R -e "devtools::install_version('emmeans', version = '1.10.4', dependencies = T)"
RUN R -e "devtools::install_version('scales', version = '1.3.0', dependencies = T)"
RUN R -e "devtools::install_version('qwraps2', version = '0.6.0', dependencies = T)"
RUN R -e "devtools::install_github('crsh/papaja')"
RUN R -e "devtools::install_version('kableExtra', version = '1.4.0', dependencies = T)"
RUN R -e "devtools::install_version('lmerTest', version = '3.1-3', dependencies = T)"
RUN R -e "devtools::install_version('ggdist', version = '3.3.2', dependencies = T)"
RUN R -e "devtools::install_version('ggpubr', version = '0.6.0', dependencies = T)"
RUN R -e "devtools::install_version('conflicted', version = '1.2.0', dependencies = T)"
RUN R -e "devtools::install_version('ggtext', version = '0.1.2', dependencies = T)"
RUN R -e "devtools::install_version('lme4', version = '1.1-35.5', dependencies = T)"
RUN R -e "devtools::install_version('Matrix', version = '1.7-0', dependencies = T)"
RUN R -e "devtools::install_version('irr', version = '0.84.1', dependencies = T)"
RUN R -e "devtools::install_version('geomtextpath', version = '0.1.4', dependencies = T)"
RUN R -e "devtools::install_version('ggh4x', version = '0.2.8', dependencies = T)"
RUN R -e "devtools::install_version('ordinal', version = '2023.12-4.1', dependencies = T)"
RUN R -e "devtools::install_version('effectsize', version = '0.8.9', dependencies = T)"
RUN R -e "devtools::install_github('bbc/bbplot', dependencies = T)"