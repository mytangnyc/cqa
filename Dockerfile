FROM python:slim

ENV container docker

WORKDIR /cqa

# Install and use latest versions of vim and conda
RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    apt-get install -y emacs && \
    rm -rf /var/lib/apt/lists/*

RUN curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -n base -c defaults conda

# Install python packages via conda
COPY ./environment.yaml ./environment.yaml
RUN conda env create -f environment.yaml

# Ensure conda commands available when in container
RUN echo ". /miniconda/etc/profile.d/conda.sh" >> ~/.bashrc

#Matplotlib on Mac - stack trace error, try the following
#$ mkdir -p ~/.matplotlib
#$ echo “backend: TkAgg” > ~/.matplotlib/matplotlibrc