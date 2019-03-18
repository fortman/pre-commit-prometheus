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
