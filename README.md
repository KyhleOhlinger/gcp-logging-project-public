# gcp-logging-project

Welcome to my gcp-logging-project. I have been working on a creating an open source GCP threat hunting lab (to be released later this year..) and during that time the importance having the ability to; automate the creation of several projects, capture logging in a central repository, and create billing alerts automatically, became clear. 

This project uses Terraform and GitHub Actions to create a baseline for new GCP projects. The main modules that are used within the Terraform project are **billing** and **logging**. The logging module includes Terraform code to create Storage Bucket and BigQuery log sinks for both the individual GCP project as well as for the centralized logging project, while the billing module handles budgets and alerting channels for your specified budget thresholds. An example of the directory structure for this project is provided below:

```bash
├───.github
│   └───workflows
└───terraform
    └───gcp-core
        └───modules
            ├───billing
            └───logging
```

If you would like to read more about how I created this project, I have a [blog post](https://ohlinger.co/posts/centralizing-gcp-logging/) available on my website.