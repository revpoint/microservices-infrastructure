## Logstash

Logging role for deploying and managing [Logstash](http://logstash.net) 1.5 with Docker and systemd.

## Variables

You can use these variables to customize your Logstash installations.

| var | description | default |
|-----|-------------|---------|
|`logstash_input_docker`|read Docker containers JSON type logs|yes|
|`logstash_input_mesos`|read Mesos logs|yes|
|`logstash_input_syslog`|read RFC3164 syslog messages|yes|
|`logstash_input_collectd`|read events from the collectd binary protocol|yes|
|`logstash_output_stdout`|a simple print to STDOUT|yes|
|`logstash_output_logentries`|forward logs to [logentries](https://logentries.com/)|no|
|`logstash_logentries_token`|unique token provided by logentries|no|
