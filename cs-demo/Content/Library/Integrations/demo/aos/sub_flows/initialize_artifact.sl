namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host
    - username
    - password
    - artifact_url:
        required: false
    - script_url
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
            - second_string: ''
        navigate:
          - SUCCESS: copy_script
          - FAILURE: remote_copy
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${script_url}'
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_script
          - FAILURE: delete_script
    - delete_script:
        do:
          Integrations.demo.aos.tools.delete_file:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - filename: '${script_name}'
        navigate:
          - SUCCESS: is_true
          - FAILURE: on_failure
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(command_return_code == '0')}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
    - remote_copy:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${artifact_url}'
        publish:
          - artifact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_artifact_given:
        x: 195
        y: 1
        navigate:
          5862f95d-24fa-623f-6622-3876dce95b8b:
            vertices:
              - x: 208
                y: 81
            targetId: copy_script
            port: SUCCESS
      copy_script:
        x: 265
        y: 145
      execute_script:
        x: 57
        y: 317
      delete_script:
        x: 197.01388549804688
        y: 330.03125
      is_true:
        x: 481
        y: 276
        navigate:
          f6eccf32-f4c3-00cc-a4ef-418947a79bc1:
            targetId: 5c562279-551c-f653-453a-3724e6de581b
            port: 'TRUE'
          363c2059-2a99-914a-3fdc-a3c9db846825:
            targetId: 644aca4b-f5da-ef75-d270-5776bb5d06db
            port: 'FALSE'
      remote_copy:
        x: 46
        y: 143
    results:
      FAILURE:
        644aca4b-f5da-ef75-d270-5776bb5d06db:
          x: 437
          y: 433
      SUCCESS:
        5c562279-551c-f653-453a-3724e6de581b:
          x: 424
          y: 123
