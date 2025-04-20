import json
import boto3
import hashlib
import os

# Initialize DynamoDB
dynamodb = boto3.resource('dynamodb')

table_name = os.environ.get("TABLE_NAME")
table = dynamodb.Table(table_name)

BASE_URL = os.environ.get("BASE_URL", "")

def lambda_handler(event, context):
    try:
        body = json.loads(event["body"])
        long_url = body.get("long_url")

        if not long_url:
            return {
                "statusCode": 400,
                "headers": {
                    "Access-Control-Allow-Origin": "*",
                    "Content-Type": "application/json"
                },
                "body": json.dumps({"error": "Missing long_url parameter"})
            }

        # Generate short hash
        short_hash = hashlib.md5(long_url.encode()).hexdigest()[:6]
        short_url = BASE_URL.rstrip("/") + "/" + short_hash  # Safe slash handling

        # Store in DynamoDB
        table.put_item(Item={
            "shortId": short_hash,
            "long_url": long_url
        })

        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",  # or specific domain
                "Access-Control-Allow-Methods": "POST, OPTIONS",
                "Access-Control-Allow-Headers": "*"
            },
            "body": json.dumps({"short_url": short_url})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Content-Type": "application/json"
            },
            "body": json.dumps({"error": str(e)})
        }
