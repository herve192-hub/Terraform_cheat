"""Minimal AWS Lambda handler for the Terraform deployment example."""


def lambda_handler(event, context):
    """Return a greeting and echo the event supplied to the function."""
    return {
        "statusCode": 200,
        "message": "Hello from AWS Lambda provisioned with Terraform!",
        "event": event,
    }
