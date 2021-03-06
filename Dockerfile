# BioSimulations-compliant Docker image for BioNetGen <https://bionetgen.org>
#
# Build image:
#   docker build \
#     --tag crbm/biosimulations_bionetgen:2.5.0 \
#     --tag crbm/biosimulations_bionetgen:latest \
#     .
#
# Run image:
#   docker run \
#     --tty \
#     --rm \
#     --mount type=bind,source="$(pwd)"/tests/fixtures,target=/root/in,readonly \
#     --mount type=bind,source="$(pwd)"/tests/results,target=/root/out \
#     crbm/biosimulations_bionetgen:latest \
#       -i /root/in/test.omex \
#       -o /root/out
#
# Author: Ali Sinan Saglam <als251@pitt.edu>
# Author: Jonathan Karr <karr@mssm.edu>
# Date: 2020-04-13

FROM continuumio/anaconda3

# install requirements and BioNetGet
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
        cmake \
        g++ \
        git \
        make \
        perl \
        vim \
    \
    && git clone https://github.com/RuleWorld/bionetgen /root/bionetgen \
    && cd /root/bionetgen \
    && git submodule init \
    && git submodule update \
    && cd /root/bionetgen/bng2 \
    && make \
    \
    && apt-get remove -y \
        cmake \
        g++ \
        git \
        make \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
ENV PATH=${PATH}:/root/bionetgen/bng2

# install BioSimulations-compliant command-line interface to BioNetGen
COPY . /root/Biosimulations_BioNetGen
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
        git \
    && pip install git+https://github.com/reproducible-biomedical-modeling/Biosimulations_utils.git#egg=Biosimulations_utils \
    \
    && pip install /root/Biosimulations_BioNetGen \
    \
    && apt-get remove -y \
        git \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# setup entry point
ENTRYPOINT ["bionetgen"]
CMD []
