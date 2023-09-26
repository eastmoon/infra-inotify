FROM python:slim

# Update linux package manager
RUN apt-get update -y

# Update python package manager
RUN pip install --upgrade pip

# Install common tools
RUN apt-get install -y coreutils

# Install python requirement
RUN pip install numpy

# Setting
WORKDIR /app
