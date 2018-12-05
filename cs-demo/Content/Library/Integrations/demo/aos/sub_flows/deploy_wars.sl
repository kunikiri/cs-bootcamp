namespace: Integrations.demo.aos.sub_flows
flow:
  name: deploy_wars
  inputs:
    - tomcat_host
    - account_service_host
    - db_host
    - username: root
    - password: "${get_sp('vm_password')}"
    - url: "${get_sp('war_repo_root_url')}"
  workflow:
    - deploy_account_service:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password: '${password}'
            - artifact_url: "${url+'accountservice/target/accountservice.war'}"
            - script_url: "${get_sp('script_deploy_war')}"
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: initialize_artifact_2
    - initialize_artifact_2:
        loop:
          for: "war in 'catalog','MasterCredit','order','ROOT','ShipEx','SafePay'"
          do:
            Integrations.demo.aos.sub_flows.initialize_artifact:
              - host: '${tomcat_host}'
              - username: '${username}'
              - password: '${password}'
              - artifact_url: "${url+war.lower()+'/target/'+war+'.war'}"
              - script_url: "${get_sp('script_deploy_war')}"
              - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_account_service:
        x: 17.013885498046875
        y: 224.03125
      initialize_artifact_2:
        x: 160.01388549804688
        y: 231.03125
        navigate:
          624d39a1-6cac-e675-3c92-79b3c89ec5fc:
            targetId: 921ddf16-3f91-9b95-d1a4-1a2fa0911e88
            port: SUCCESS
    results:
      SUCCESS:
        921ddf16-3f91-9b95-d1a4-1a2fa0911e88:
          x: 282.0138854980469
          y: 93.03125
