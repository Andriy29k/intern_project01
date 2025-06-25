output "bucket_name" {
  description = "The name of the GCS bucket"
  value       = google_storage_bucket.dump_bucket.name
}

output "bucket_url" {
  description = "The public URL of the GCS bucket (for viewing in browser)"
  value       = "https://console.cloud.google.com/storage/browser/${google_storage_bucket.dump_bucket.name}"
}

output "bucket_self_link" {
  description = "The self link of the GCS bucket"
  value       = google_storage_bucket.dump_bucket.self_link
}