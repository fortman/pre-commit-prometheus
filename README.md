# pre-commit-prometheus

Pre commit checks for valid syntax of [prometheus](https://prometheus.io) config and rule files

This is a plugin for [pre-commit](https://pre-commit.com)

### Usage

To lint Prometheus Rules files, use the `prometheus-rules` hook.  Make sure to filter files passed to hook by defining the `files` section.  Note: the `entry` option below is optional and will default to the latest prometheus version.  It is shown just as an example of pinning to a specific prometheus version.

    - repo: https://github.com/fortman/pre-commit-prometheus
      rev: v1.1.1
      hooks:
      - id: check-rules
        entry: --entrypoint /bin/promtool prom/prometheus:v2.6.0
        files: >
          (?x)^(
            rules_directory/.*\.yml
          )$

To lint Prometheus Config files, use the `prometheus-config` hook.  Make sure to filter files passed to hook by defining the `files` section.  Note: the `entry` option below is optional and will default to the latest prometheus version.  It is shown just as an example of pinning to a specific prometheus version.

    - repo: https://github.com/fortman/pre-commit-prometheus
      rev: v1.1.1
      hooks:
      - id: check-config
        entry: --entrypoint /bin/promtool prom/prometheus:v2.6.0
        files: >
          (?x)^(
            config_directory/.*\.yml
          )$

To unit-test Prometheus Rule files, use the `test-rules` hook.  Make sure to filter files passed to hook by defining the `files` section.  Note: the `entry` option below is optional and will default to the latest prometheus version.  It is shown just as an example of pinning to a specific prometheus version.

In the example provided, we are setting this to always run as rule files could be changed without altering the unit tests.  Unit tests should be run against their respective rule files after any change.

    - repo: https://github.com/fortman/pre-commit-prometheus
      rev: v1.2.0
      hooks:
      - id: test-rules
        entry: --entrypoint /bin/promtool prom/prometheus:v2.18.2
        always_run: true
        files: >
          (?x)^(
            unit_test_directory/.*\.yml
          )$



### prom_coverage
prom_coverage is a ruby script to be run by pre-commit to ensure prometheus alerts are unit tested. "Are unit tested" is defined as at least 1 test with the same name as the alert. There is an option to ignore alert filenames, this is currently being used to ignore rules that are going away in the future.
#### Usage
```
- repo: https://github.com/fortman/pre-commit-prometheus
      rev: v1.3.0
      hooks:
      - id: check-coverage
        entry: bin/prom_coverage.rb
        args:
          - ../chef-cookbooks/cookbooks/pprometheus_v2/files/default/alerts/
          - ../chef-cookbooks/cookbooks/pprometheus_v2/files/default/unit-tests/
          - 80
          - rabbitmq.yml
          - redis.yml
```

**Script uses positional arguments only.**

| Pos | Description | Example Value |
| --- | --- | -- |
| 1 | rules directory | `../chef-cookbooks/cookbooks/pprometheus_v2/files/default/alerts/` |
| 2 | unit tests directory | `../chef-cookbooks/cookbooks/pprometheus_v2/files/default/unit-tests/` |
| 3 | percent coverage accepted | 80 |
| 4* | rule filename to ignore | `rabbitmq.yml redis.yml postgres.yml` |

Example successful execution output.
```
ruby bin/prom_coverage.rb \
../chef-cookbooks/cookbooks/pprometheus_v2/files/default/alerts \
../chef-cookbooks/cookbooks/pprometheus_v2/files/default/unit-tests \
65 \
rabbitmq.yml \
redis.yml \
postgres.yml \

"skiplist: [\"rabbitmq.yml\", \"redis.yml\", \"postgres.yml\"]"
"skipped: 14"
"coverage: 79.0%"
"accepted: 65%"
"---Missing---"
"tier2-support.yml - NovaStudentInvalidID_tier2"
"postgresql.yml - PostgreSQL_Service_Down"
"postgresql.yml - PostgreSQL_Maximum_Connections"
"postgresql.yml - PostgreSQL_High_Connections"
"postgresql.yml - PostgreSQL_Replication_Slot_Inactive"
"postgresql.yml - PostgreSQL_XID_Wraparound_Warning"
"postgresql.yml - PostgreSQL_XID_Wraparound_Critical"
"postgresql.yml - PostgreSQL_Force_Freeze"
"postgresql.yml - PostgreSQL_Replication_Lag"
"stparser-assets.yml - StparserDDXML1TemplatesError"
"stparser-assets.yml - StparserDDXML2TemplatesError"
"stparser-assets.yml - StparserResourcesError"
"vmware.yml - Host_Warn_Cpu_Usage"
"vmware.yml - Host_Crit_Cpu_Usage"
"vmware.yml - Host_Warn_Mem_Usage"
"vmware.yml - Host_Crit_Mem_Usage"
"vmware.yml - Predict_Disk_Space_Warn"
"vmware.yml - Predict_Disk_Space_Crit"
"networking.yml - HighCpuUtilizationManagement"
"networking.yml - HighCpuUtilizationDataPlane"
"networking.yml - DeviceStatusUnkownOrIssue"
```
Example fail execution output.
```
% ruby bin/prom_coverage.rb \
> ../chef-cookbooks/cookbooks/pprometheus_v2/files/default/alerts \
> ../chef-cookbooks/cookbooks/pprometheus_v2/files/default/unit-tests \
> 85 \
> rabbitmq.yml \
> redis.yml \
> postgres.yml \
>
"skiplist: [\"rabbitmq.yml\", \"redis.yml\", \"postgres.yml\"]"
"skipped: 14"
"coverage: 79.0%"
"accepted: 85%"
"---Missing---"
"tier2-support.yml - NovaStudentInvalidID_tier2"
"postgresql.yml - PostgreSQL_Service_Down"
"postgresql.yml - PostgreSQL_Maximum_Connections"
"postgresql.yml - PostgreSQL_High_Connections"
"postgresql.yml - PostgreSQL_Replication_Slot_Inactive"
"postgresql.yml - PostgreSQL_XID_Wraparound_Warning"
"postgresql.yml - PostgreSQL_XID_Wraparound_Critical"
"postgresql.yml - PostgreSQL_Force_Freeze"
"postgresql.yml - PostgreSQL_Replication_Lag"
"stparser-assets.yml - StparserDDXML1TemplatesError"
"stparser-assets.yml - StparserDDXML2TemplatesError"
"stparser-assets.yml - StparserResourcesError"
"vmware.yml - Host_Warn_Cpu_Usage"
"vmware.yml - Host_Crit_Cpu_Usage"
"vmware.yml - Host_Warn_Mem_Usage"
"vmware.yml - Host_Crit_Mem_Usage"
"vmware.yml - Predict_Disk_Space_Warn"
"vmware.yml - Predict_Disk_Space_Crit"
"networking.yml - HighCpuUtilizationManagement"
"networking.yml - HighCpuUtilizationDataPlane"
"networking.yml - DeviceStatusUnkownOrIssue"
promcheck.rb:127:in `<main>': accepted 85 > actual coverage 79.0 (RuntimeError)
```
