import json
import boto3
import os
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Use environment variable for table name
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ.get("TABLE_NAME"))

def lambda_handler(event, context):
    try:
        shortId = event.get('pathParameters', {}).get('shortId')
        if not shortId:
            return {
                "statusCode": 400,
                "headers": {
                    "Access-Control-Allow-Origin": "*",
                    "Content-Type": "application/json"
                },
                "body": json.dumps({"error": "Missing shortId in path"})
            }

        logger.info(f"Looking up shortId: {shortId}")
        response = table.get_item(Key={'shortId': shortId})
        logger.info(f"DynamoDB response: {response}")

        if 'Item' not in response:
            return {
                "statusCode": 404,
                "headers": {
                    "Access-Control-Allow-Origin": "*",
                    "Content-Type": "application/json"
                },
                "body": json.dumps({"error": "Short URL not found"})
            }

        return {
            "statusCode": 301,
            "headers": {
                "Location": response['Item']['long_url'],
                "Access-Control-Allow-Origin": "*"
            }
        }

    except Exception as e:
        logger.error(f"Error: {str(e)}")
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Content-Type": "application/json"
            },
            "body": json.dumps({"error": str(e)})
        }
