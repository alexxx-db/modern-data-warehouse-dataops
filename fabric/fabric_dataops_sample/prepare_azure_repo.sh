#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace # For debugging

# Source common functions
. ./scripts/common.sh

# Source environment variables
source ./.env

# Log all outputs and errors to a log file
log_file="setup_azdo_repo_${BASE_NAME}_$(date +"%Y%m%d_%H%M%S").log"
exec > >(tee -a "${log_file}")
exec 2>&1

log "############  STARTING AZDO REPOSITORY SETUP  ############" "info"
log "############   CREATING AZDO PIPELINE FILES   ############" "info"

# Azure DevOps (AzDo) pipeline template files
ci_artifacts_pipeline_template="devops/templates/pipelines/azure-pipelines-ci-artifacts.yml"
ci_qa_cleanup_pipeline_template="devops/templates/pipelines/azure-pipelines-ci-qa-cleanup.yml"
ci_qa_pipeline_template="devops/templates/pipelines/azure-pipelines-ci-qa.yml"

# Azure DevOps (AzDo) pipeline actual files (to be created)
ci_artifacts_pipeline="devops/azure-pipelines-ci-artifacts.yml"
ci_qa_cleanup_pipeline="devops/azure-pipelines-ci-qa-cleanup.yml"
ci_qa_pipeline="devops/azure-pipelines-ci-qa.yml"

# Copy the pipeline template files to the actual pipeline files
cp "${ci_artifacts_pipeline_template}" "${ci_artifacts_pipeline}"
cp "${ci_qa_cleanup_pipeline_template}" "${ci_qa_cleanup_pipeline}"
cp "${ci_qa_pipeline_template}" "${ci_qa_pipeline}"

for i in "${!ENVIRONMENT_NAMES[@]}"; do
    environment_name="${ENVIRONMENT_NAMES[$i]}"
    branch_name="${GIT_BRANCH_NAMES[$i]}"
    base_name="${BASE_NAME}"

    log "Processing environment '${environment_name}', branch '${branch_name}', and base name '${base_name}'." "info"

    azdo_variable_group_name="vg-${base_name}-${environment_name}"
    azdo_service_connection_name="sc-${base_name}-${environment_name}"
    azdo_git_branch_name="${branch_name}"

    # Calculate the index (i+1) for placeholder replacement
    local index=$((i + 1))
    
    placeholder_branch_name="<ENV${index}_BRANCH_NAME>"
    placeholder_variable_group_name="<ENV${index}_VARIABLE_GROUP_NAME>"
    placeholder_service_connection_name="<ENV${index}_SERVICE_CONNECTION_NAME>"

    # Replace placeholders in the pipeline files
    replace_in_file "${placeholder_branch_name}" "${azdo_git_branch_name}" "${ci_artifacts_pipeline}"
    replace_in_file "${placeholder_variable_group_name}" "${azdo_variable_group_name}" "${ci_artifacts_pipeline}"
    replace_in_file "${placeholder_service_connection_name}" "${azdo_service_connection_name}" "${ci_artifacts_pipeline}"

    replace_in_file "${placeholder_branch_name}" "${azdo_git_branch_name}" "${ci_qa_cleanup_pipeline}"
    replace_in_file "${placeholder_variable_group_name}" "${azdo_variable_group_name}" "${ci_qa_cleanup_pipeline}"
    replace_in_file "${placeholder_service_connection_name}" "${azdo_service_connection_name}" "${ci_qa_cleanup_pipeline}"

    replace_in_file "${placeholder_branch_name}" "${azdo_git_branch_name}" "${ci_qa_pipeline}"
    replace_in_file "${placeholder_variable_group_name}" "${azdo_variable_group_name}" "${ci_qa_pipeline}"
    replace_in_file "${placeholder_service_connection_name}" "${azdo_service_connection_name}" "${ci_qa_pipeline}"
done

log "############    AZDO PIPELINE FILES CREATED   ############" "success"
log "############ COPYING LOCAL FILES TO AZDO REPO ############" "info"

for i in "${!ENVIRONMENT_NAMES[@]}"; do
    branch_name="${GIT_BRANCH_NAMES[$i]}"

    # If the current branch is the first branch, then the base branch is empty
    local base_branch_name=""
    if [[ $i -gt 0 ]]; then
        base_branch_name="${GIT_BRANCH_NAMES[$((i-1))]}"
    fi

    log "Processing branch '${branch_name}'." "info"
    python3 ./scripts/setup_azdo_repository.py \
        --organization_name "${GIT_ORGANIZATION_NAME}" \
        --project_name "${GIT_PROJECT_NAME}" \
        --repository_name "${GIT_REPOSITORY_NAME}" \
        --branch_name "${branch_name}" \
        --base_branch_name "${base_branch_name}" \
        --username "${GIT_USERNAME}" \
        --token "${GIT_PERSONAL_ACCESS_TOKEN}"
done

log "############    FILES COPIED AND COMMITTED    ############" "success"
log "############  AZDO REPOSITORY SETUP COMPLETED ############" "success"
