# Big Data

## Setup

In Docker, the project root directory is mapped to `/usr/src`.

File `cluster/local.env` provides configuration for running cluster in a local
network rather then docker (ie. via SSH). For now, this only includes 
environment variables that are normally set in `Dockerfile`.
