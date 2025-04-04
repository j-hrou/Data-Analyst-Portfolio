# Microplastic pollution along the coast of Cyprus: Occurrence in beach sediments of marine turtle nesting beaches

## Overview

This repository contains the data and R code for my Master of Science (MSc) dissertation project in Environmental Protection & Management from the University of Edinburgh. The project investigated the occurrence and characteristics of microplastic pollution in the beach sediments of important marine turtle nesting sites along the coast of Cyprus. Cyprus is located in the Eastern Mediterranean, a region known to be heavily affected by plastic pollution. Given that the studied beaches are critical nesting habitats for endangered Green Turtles (Chelonia mydas) and vulnerable Loggerhead Turtles (Caretta caretta), understanding the extent of microplastic contamination is crucial for conservation efforts. This study provides a baseline survey for microplastic pollution in the western, southern, and eastern regions of Cyprus, complementing previous research focused on the northern coast.

## Project Goals

The primary objectives of this dissertation project were to:

* Evaluate the abundance, classification, distribution, and spatial variation of microplastics (>1mm) across 14 marine turtle nesting beaches in Cyprus.
* Investigate potential relationships between microplastic concentration and factors like beach orientation and geographical location.
* Explore how microplastic abundance varies with depth within the beach sediment (0-2cm vs 2.1-10cm).
* Characterise the types of microplastics found (e.g., fragments, sheets, industrial pellets).
* Assess whether current policies and legislation are effective in controlling microplastic pollution in Cyprus.
* Propose recommendations for future research priorities and potential policy adjustments.

## Key Research Questions Addressed

This research aimed to answer the following questions:

* What is the abundance, distribution, and type of microplastics (1-5mm) present in the sediments of key marine turtle nesting beaches across the east, south, and west coasts of Cyprus? 
* How do microplastic concentrations vary between different beaches and regions, and is there a significant relationship with beach orientation?
* Is there a significant difference in microplastic abundance between surface sediments (0-2cm) and deeper sediments (2.1-10cm) within the turtle nesting zone?
* What are the dominant categories (fragments, sheets, industrial pellets, etc.) of microplastics found on these beaches?
* What are the potential sources of this microplastic pollution, considering local factors and broader Mediterranean circulation patterns? 
* What are the implications of the observed pollution levels for endangered marine turtle populations nesting on these beaches?

## Project Structure

* **`data/`**: Contains the raw datasets collected during the study in CSV format. Includes details on microplastic counts, weights, types per sample, and sample locations.
* **`code/`**: Contains the R scripts used for all statistical analyses performed and visualisations produced in the dissertation.
* **`dissertation/`**: Contains the full dissertation document (PDF) for context and detailed methodology/results.
* **`README.md`**: This document.

## Tools Used

* **Field Sampling:** Manual sediment collection using trowels, Sieves (1mm and 5mm mesh), Handheld GPS (Garmin GPSMAP® 78) for location recording.
* **Laboratory Analysis:** Visual sorting and categorisation of microplastics, Weighing scales (accuracy 0.01g or 1.0g). Density separation using water was employed where visual isolation was difficult.
* **Data Analysis:** R (Version used: RStudio 1.2.5042) for statistical analysis (Wilcoxon signed-rank test, Kruskal-Wallis test, pairwise Wilcoxon rank sum test) and data visualisations (ggplot2).
* **Mapping/Planning:** Google Earth Pro (for initial beach measurements).

## Skills Demonstrated

* Environmental Field Sampling Design & Execution
* Laboratory Procedures & Data Recording
* Statistical Analysis in R (Non-parametric tests)
* Data Visualisation in R (ggplot2)
* Data Management & Manipulation (CSV)
* Scientific Literature Review & Synthesis
* Environmental Policy Analysis
* Scientific Writing & Communication (Dissertation format)
