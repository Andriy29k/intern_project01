resource "google_storage_bucket" "dump_bucket" {
  name          = "class-schedule-dump"
  location      = "US"
  storage_class = "STANDARD"

  versioning {
    enabled = false
  }

  uniform_bucket_level_access = true

  labels = {
    environment = "prod"
    type        = "sql-dump"
  }
  
}