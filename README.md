---
page_type: sample
languages:
- python
- csharp
- typeScript
- bicep
products:
- azure
- microsoft-fabric
- azure-sql-database
- azure-data-factory
- azure-databricks
- azure-stream-analytics
- azure-synapse-analytics
description: "Code samples showcasing how to apply DevOps concepts to common data engineering patterns and architectures leveraging different Microsoft data platform technologies."
---

# DataOps

This repository contains numerous code samples and artifacts on how to apply DevOps principles to common data engineering patterns and architectures utilizing Microsoft data platform technologies.

The samples are either focused on a single microsoft service ([Single-Technology Samples](#single-technology-samples)) or showcases an end-to-end data pipeline solution as a reference implementation ([End-to-End Samples](#end-to-end-samples)). Each sample contains code and artifacts related to one or more of the following capabilities:

- Infrastructure as Code (IaC)
- Build and Release Pipelines (CI/CD)
- Testing
- Observability / Monitoring

## Single-Technology Samples

| Technology | Samples |
| ---------- | ------- |
| [Microsoft Fabric](./single_tech_samples/fabric/README.md) | ▪️ [CI/CD for Microsoft Fabric](./single_tech_samples/fabric/fabric_ci_cd/README.md)<br> ▪️ [Feature engineering on Microsoft Fabric](./single_tech_samples/fabric/feature_engineering_on_fabric/README.md) |
| [Azure SQL database](./single_tech_samples/azuresql/README.md) | ▪️ [CI/CD for Azure SQL database](./single_tech_samples/azuresql/azuresql_ci_cd/README.md) |
| [Azure Data Factory](./single_tech_samples/datafactory/README.md) | ▪️ [CI/CD for ADF with Auto publish](./single_tech_samples/datafactory/adf_cicd_auto_publish/README.md)<br> ▪️ [Data pre-processing using Azure Batch](./single_tech_samples/datafactory/adf_data_pre_processing_with_azure_batch/README.md) |

## End-to-End Samples

### DataOps for Medallion with Azure Data Factory and Azure Databricks

This [sample](e2e_samples/parking_sensors/) demonstrates batch, end-to-end data pipeline utilizing Azure Data Factory and Azure Databricks built according to the [medallion architecture](https://learn.microsoft.com/azure/databricks/lakehouse/medallion), along with a corresponding CI/CD process, observability and automated testing.

[![Medallion with Azure Data Factory and Azure Databricks](docs/images/CI_CD_process_simplified.png "Architecture")](e2e_samples/parking_sensors/)

### DataOps for Medallion with Microsoft Fabric

- This [sample](./e2e_samples/fabric_dataops_sample/) would demonstrate end-to-end batch data processing utilizing Microsoft Fabric built according to the [medallion architecture](https://learn.microsoft.com/azure/databricks/lakehouse/medallion), along with a corresponding CI/CD process, observability and automated testing.

  In the current version, the sample is showcasing the deployment of Azure and Fabric resources together using Terraform. The deployment uses a service principal or managed identity for authentication where supported and falls back to Entra user authentication where it is not.

## Contributing

This project welcomes contributions and suggestions. Please see our [Contributing guide](/CONTRIBUTING.md).
