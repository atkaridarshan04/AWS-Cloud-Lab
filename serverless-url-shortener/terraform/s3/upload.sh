#!/bin/bash

# Set your bucket name here
BUCKET_NAME="frontend-s3-bucket-xyz-123"

# Sync all files from frontend/ to the S3 bucket root
aws s3 sync . s3://$BUCKET_NAME --delete

echo "Static files uploaded to S3 bucket: $BUCKET_NAME"
