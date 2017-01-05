require 'rest-client'
require 'json'
require 'pry'

base_url = "https://quiet-refuge-3333.herokuapp.com/"
header_str = {"Content-Type":"application/json", "Authorization":"Basic YWRtaW46cGFzc3dvcmQ="}

# accounts
url = base_url + "accounts.json"
response_get = RestClient.get(url, headers=header_str)

payload = {
    "account": {
        "user_id": 1,
        "assigned_to": 1,
        "name": "account_#{Time.now.strftime("%Y%m%d_%H%M%S")}",
        "access": "Public",
        "website": "",
        "toll_free_phone": "",
        "phone": "",
        "fax": "",
        "deleted_at": nil,
        "created_at": "2016-11-30T15:18:13.990-08:00",
        "updated_at": "2016-11-30T15:18:13.990-08:00",
        "email": "",
        "background_info": nil,
        "rating": 0,
        "category": nil,
        "subscribed_users": []
    }
}

response_post = RestClient.post(url, payload.to_json, headers=header_str)
binding.pry

# Tasks
url = base_url + "tasks.json"
response_tasks_get = RestClient.get(url, headers=header_str)

payload_task = {
            "task": {
                "user_id": 1,
                "assigned_to": nil,
                "completed_by": nil,
                "name": "task_#{Time.now.strftime("%Y%m%d_%H%M%S")}",
                "asset_id": nil,
                "asset_type": "",
                "priority": nil,
                "category": "",
                "bucket": "due_asap",
                "due_at": nil,
                "completed_at": nil,
                "deleted_at": nil,
                "created_at": "2016-11-30T14: 48: 12.901-08: 00",
                "updated_at": "2016-11-30T14: 48: 12.901-08: 00",
                "background_info": nil,
                "subscribed_users": [
                    
                ]
            }
        }
response_tasks_post = RestClient.post(url, payload_task.to_json, headers=header_str)

# Campaigns
url = base_url + "campaigns.json"
resp_camp_get = RestClient.get(url, headers=header_str)

payload_campaign = {
    "campaign": {
        "user_id": 1,
        "assigned_to": 1,
        "name": "test_#{Time.now.strftime("%Y%m%d_%H%M%S")}",
        "access": "Public",
        "status": "planned",
        "budget": nil,
        "target_leads": nil,
        "target_conversion": nil,
        "target_revenue": nil,
        "leads_count": nil,
        "opportunities_count": nil,
        "revenue": nil,
        "starts_on": nil,
        "ends_on": nil,
        "objectives": "",
        "deleted_at": nil,
        "created_at": "2016-12-02T10: 27: 37.943-08: 00",
        "updated_at": "2016-12-02T10: 27: 37.943-08: 00",
        "background_info": nil,
        "subscribed_users": []
    }
}
resp_camp_post = RestClient.post(url, payload_campaign.to_json, headers=header_str)

# TODO: Leads

binding.pry