namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.47
    - username: root
    - password: admin@123
    - filename: deploy_war.sh
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      ssh_command:
        x: 155.01388549804688
        y: 197.03125
        navigate:
          95372a4d-0df7-94cd-beeb-84e0a416fb04:
            targetId: c1a3ddc6-7027-2e38-ba0d-9c6e874d6a8b
            port: SUCCESS
    results:
      SUCCESS:
        c1a3ddc6-7027-2e38-ba0d-9c6e874d6a8b:
          x: 329
          y: 191
