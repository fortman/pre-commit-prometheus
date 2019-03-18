# pre-commit-prometheus

Pre commit checks for prometheus config and rule files

This is a plugin for [pre-commit](https://pre-commit.com) that will run various ruby tools for linting and testing.

### Usage

To lint Prometheus Rules files, use the `prometheus-rules` hook.  Make sure to filter files passed to hook by defining the `files` section

    - repo: https://github.com/fortman/pre-commit-prometheus
      rev: v1.0.o
      hooks:
      - id: check-rules
        stages: [commit]
        files: >
          (?x)^(
              rules_directory/.*\.yml
          )$
        # prometheus docker tag
        args:
        - v2.6.0

To lint Prometheus Config files, use the `prometheus-config` hook.  Make sure to filter files passed to hook by defining the `files` section

    - repo: https://github.com/fortman/pre-commit-prometheus
      rev: v1.0.o
      hooks:
      - id: check-config
        stages: [commit]
        files: >
          (?x)^(
              config_directory/.*\.yml
          )$
        # prometheus docker tag
        args:
        - v2.6.0