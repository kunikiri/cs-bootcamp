namespace: Integrations.demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - host
    - username
    - password
    - url
  workflow:
    - extract_filename:
        do:
          io.cloudslang.demo.aos.tools.extract_filename:
            - url: '${url}'
        publish:
          - filename
        navigate:
          - SUCCESS: get_file
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${host}'
            - destination_path: "${get_sp('script_location')}"
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - filename: '${filename}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      extract_filename:
        x: 97
        y: 116
      get_file:
        x: 108.01388549804688
        y: 268.03125
      remote_secure_copy:
        x: 279.0138854980469
        y: 254.03125
        navigate:
          83e3ac18-2004-db24-1773-82813103b263:
            targetId: ce8be864-d732-992c-a391-1f7f634ded93
            port: SUCCESS
    results:
      SUCCESS:
        ce8be864-d732-992c-a391-1f7f634ded93:
          x: 259.0138854980469
          y: 117.03125
