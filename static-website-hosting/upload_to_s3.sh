#!/bin/bash

# Usage: ./upload_to_s3.sh <bucket-name>

# Variables
BUCKET_NAME=$1
LOCAL_DIR="./src"

# Validate input
if [ -z "$BUCKET_NAME" ]; then
  echo "Usage: ./upload_to_s3.sh <bucket-name>"
  exit 1
fi

# Sync the src/ directory to the S3 bucket
aws s3 sync "$LOCAL_DIR" "s3://$BUCKET_NAME" --delete

# Check the result
if [ $? -eq 0 ]; then
  echo "✅ Upload completed successfully to S3 bucket: $BUCKET_NAME"
else
  echo "❌ Upload failed. Please check AWS CLI configuration and permissions."
fi
