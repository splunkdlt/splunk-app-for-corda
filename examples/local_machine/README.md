# Splunk Connect for Corda (alpha)

## Local machine installation example

Splunk Connect for Corda contains the necessary components and instructions in order to collect and ingest Corda application logs, traces, JMX metrics and information from the *Corda Enterprise Network Manager (coming soon)*.  Optionally system metrics and logs can be collected for additional monitoring insights no matter the platform nodes are being hosted on.  **This is your one-stop shop for full observability of a Corda network!**

### OpenTelemetry Collector, collectd and Splunk Universal Forwarder
There are several technologies used in order to collect and send everything to Splunk.  These have been packaged up and configured specifically to work with Corda nodes and Splunk to make installation quick and easy.
  - [OpenTelemetry Collector](https://github.com/open-telemetry) for scraping & collecting Prometheus metrics as well as traces over the [Splunk HTTP Event Collector (HEC)](https://docs.splunk.com/Documentation/Splunk/latest/Data/UsetheHTTPEventCollector)
  - Prometheus Java Agent for extracting JMX metrics from Corda
  - [collectd](https://collectd.org/) for making system metrics available and sending to Splunk over the Splunk HTTP Event Collector (HEC)
  - [Splunk Universal Forwarder](https://docs.splunk.com/Documentation/Forwarder/latest/Forwarder/Abouttheuniversalforwarder) for sending both system logs and Corda application logs to Splunk.
  - *Corda Enterprise Network Manager API (coming soon)*

#### Traces
Splunk Connect for Corda integrates with the [OpenTelemetry tracing framework](https://opentelemetry.io/docs/) to collect traces of Cordapps and the Corda network. By default, it augments through [auto-instrumentation](https://github.com/open-telemetry/opentelemetry-java-instrumentation) any database call or JMS message exchange, and reports them in the OLTP standard. Additionally, you can [define spans manually](https://github.com/open-telemetry/opentelemetry-java/blob/master/QUICKSTART.md#tracing) in Cordapps to report application-specific traces.

### Installation

*Note - this will require a restart of all Corda nodes you are setting this up on.

1. Installing and preparing Splunk
2. Install Splunk Connect for Corda components on Corda Nodes
3. Validate data sources and functionality

### Preparing Splunk

These instructions are based on a single Splunk instance.  For a distributed environment you should contact your Splunk Administrator or consult [Splunk documentation](https://docs.splunk.com/Documentation/Splunk/latest/Deploy/Deploymentcharacteristics). The scripts included use example index names we have created.  Your Splunk Administrator may ask you to utilize different indexes.
- [Install Splunk](https://docs.splunk.com/Documentation/Splunk/latest/Installation/Chooseyourplatform)
- [Install Splunk Add-on for Infrastructure](https://splunkbase.splunk.com/app/4217/) and [Splunk App for Infrastructure](https://splunkbase.splunk.com/app/3975/).  Restart Splunk. (This step is only required if you are collecting infrastructure logs and metrics)
- [Create the following indexes](https://docs.splunk.com/Documentation/Splunk/latest/Indexer/Setupmultipleindexes): corda_logs (of type events), corda_traces (of type events) and corda_metrics (of type metrics)
- [Enable HTTP Event Collector (HEC)](https://docs.splunk.com/Documentation/Splunk/latest/Data/UsetheHTTPEventCollector#Configure_HTTP_Event_Collector_on_Splunk_Enterprise)
- Create a token named "otel_token". This token will handle the Corda JMX metrics and traces using opemtelemetry
		-- Make sure to add both indexes (corda_metrics, corda_traces) to selected indexes
		-- Make the default index corda_metrics
		-- Copy down the otel_token HEC token.
- Create a token named "sai_collectd". This token will handle the node infrastructure collectd metrics
		-- Make sure to add indexes (em_metrics and em_meta) to selected indexes
		-- Make the default index em_metrics
		-- Copy down the sai_collectd HEC token
- Update the [`props.conf`](./props.conf) file located at `/opt/splunk/etc/system/local` with the config to tell the Splunk indexer where to find the timestamp in the new Corda JSON logs.
- Install the Splunk Connect for Corda app on your search head.

### Install Splunk Connect for Corda components on Corda Nodes

*Note - this will require a restart of all Corda nodes you are setting this up on.

- Unpack or clone repo onto each node. Run the following on every node.
1. Install Opentelemetry collector
```./install_otel_collector.sh [corda host] [splunk host] [splunk otel hec token]```
2. Install Splunk Universal Forwarder and collectd
```./install_collectd_and_splunk_uf.sh [corda logs dir] [splunk host] [splunk sai_collectd hec token]```
- *Note the syslog information will go to the default Splunk indexed called "main" unless you specify otherwise in the deployed inputs.conf found here after the script runs: "/opt/splunkforwarder/etc/apps/splunk_app_infra_uf_config/local/inputs.conf"

3. Install Java Agents for Prometheus and Opentelemetry
```./fetch_javaagents.sh```

4. Start Processes and Restart Nodes
 - Run ```./start_otel_collector.sh``` to start the otel collector
 - Run ```./start_splunk_uf.sh``` to restart the Universal Forwarder
 - Stop your Corda node and then run ```./start_node.sh [otel collector host/ip]``` (or ```./start_firewall.sh``` to run a firewall instead of a node) to restart

### Validate data sources and functionality

- You should now see data coming into Splunk.
-- For Corda application logs you should see data coming in the ```index=corda_logs``` index
-- For Corda JMX metrics you can visualize them in the Analytics Workspace (Look "Analytics" in the top navigation bar)
-- For System infrastructure metrics on each node you should see data when going into the Splunk App for Infrastructure.
-- For System Logs you should see data coming in the ```index=main``` index (or whatever index you specficied)
-- If you enabled tracing you should see data in the ```index=corda_traces``` index.

If you have any questions please reach out to us at blockchain@splunk.com
