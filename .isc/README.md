# Predixy Buildkite Pipeline

This directory contains the Buildkite pipeline configuration for the Predixy project.

## Pipeline Structure

The pipeline consists of the following steps:

1. **Build Docker Container** - Builds the Predixy Docker image
2. **Run Docker Container** - Runs the container briefly to verify it starts correctly

## Configuration Files

- `config.yml` - Required by Buildkite to mark this directory as buildable
- `pipeline.yml` - Defines the Buildkite pipeline steps

## Customizing the Pipeline

To add more sophisticated testing or deployment steps, modify the `pipeline.yml` file. 