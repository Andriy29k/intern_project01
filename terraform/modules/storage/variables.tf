variable "project_id" {
    description = "The ID of the GCP project where resources will be created"
    type        = string
}

variable "bucket_name" {
    description = "The name of the GCS bucket to create"
    type        = string
    default     = "class-schedule-dump"
  
}

variable "location" {
    description = "The location for the GCS bucket"
    type        = string
  
}