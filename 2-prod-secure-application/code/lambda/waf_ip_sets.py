import boto3
import os

waf = boto3.client('wafv2')
ssm = boto3.client('ssm')

def lambda_handler(event, context):
    ipset_name = os.environ['IPSET_NAME']          # e.g., "blocked-ips"
    ssm_param_name = os.environ['SSM_PARAM']       # e.g., "/waf/blocked_ips"
    scope = "CLOUDFRONT"                            # WAF scope for CloudFront

    # Step 1: Read blocked IPs from SSM Parameter Store
    try:
        ssm_response = ssm.get_parameter(Name=ssm_param_name)
        ip_list = ssm_response['Parameter']['Value'].split(',')
        ip_list = [ip.strip() for ip in ip_list if ip.strip()]
    except Exception as e:
        print(f"Error fetching SSM parameter: {e}")
        return {"status": "error", "message": str(e)}

    if not ip_list:
        print("No IPs to block.")
        return {"status": "no_update", "message": "Empty IP list"}

    # Step 2: Get current IPSet details
    try:
        response = waf.list_ip_sets(Scope=scope)
        ip_sets = response['IPSets']
        ipset = next((i for i in ip_sets if i['Name'] == ipset_name), None)
        if not ipset:
            raise Exception(f"IPSet {ipset_name} not found.")

        ipset_id = ipset['Id']
        ipset_arn = ipset['ARN']

        ipset_detail = waf.get_ip_set(Name=ipset_name, Scope=scope, Id=ipset_id)
        lock_token = ipset_detail['LockToken']

        # Step 3: Format IPs (assumes IPv4 only; extend for IPv6 if needed)
        addresses = [f"{ip}/32" for ip in ip_list]

        # Step 4: Update IPSet
        waf.update_ip_set(
            Name=ipset_name,
            Scope=scope,
            Id=ipset_id,
            LockToken=lock_token,
            Addresses=addresses
        )

        print(f"Successfully updated IPSet {ipset_name} with IPs: {addresses}")
        return {"status": "success", "ips_blocked": addresses}

    except Exception as e:
        print(f"Error updating IPSet: {e}")
        return {"status": "error", "message": str(e)}
