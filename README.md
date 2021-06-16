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

To lint Alertmanager Config files, use the `alertmanager-config` hook.  Make sure to filter files passed to hook by defining the `files` section.  Note: the `entry` option below is optional and will default to the latest alertmanager version.  It is shown just as an example of pinning to a specific alertmanager version.

    - repo: https://github.com/fortman/pre-commit-prometheus
      rev: v1.1.1
      hooks:
      - id: check-alertmanager-config
        entry: --entrypoint /bin/amtool prom/alertmanager:v0.21.0
        files: >
          (?x)^(
            config_directory/.*\.yml
          )$          
