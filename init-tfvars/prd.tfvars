# These variables are called when running the following command:
# terraform init -backend-config=./init-tfvars/prd.tfvars

# Replace the example values and remove the block comments marks to enable the variables file.

/*
bucket         = "customer-remote-state-backend-prd"
dynamodb_table = "customer-remote-state-backend-prd"
key            = "customer-account-prd.tfstate"
kms_key_id     = "arn:aws:kms:us-east-1:1234567890A:key/12345678-90AB-CDEF-GHIJ-KLMNOPKRTSUWZ"
*/