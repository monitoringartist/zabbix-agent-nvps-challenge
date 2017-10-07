[<img src="https://monitoringartist.github.io/managed-by-monitoringartist.png" alt="Managed by Monitoring Artist: DevOps / Docker / Kubernetes / AWS ECS / Zabbix / Zenoss / Terraform / Monitoring" align="right"/>](http://www.monitoringartist.com 'DevOps / Docker / Kubernetes / AWS ECS / Zabbix / Zenoss / Terraform / Monitoring')

# Zabbix Agent NVPS Challenge

Zabbix community Agent NVPS (new values per second) challenge - who will achieve
the highest Zabbix agent NVPS score.

**TL;DR:**

Use your server with preinstalled Docker + with the most powerful CPU(s) and
execute this command:

```
export USER_ID="<your public user identification>"
sudo curl -s \
https://raw.githubusercontent.com/monitoringartist/zabbix-agent-nvps-challenge/master/script.sh \
| sudo -E bash
```

Your results are submitted automatically and are available in the [Public Google Sheet](https://drive.google.com/open?id=1qv5siZ-lGa69GnibsbtYHnCMdG05zrZG7L7FCuInF08).

Current record holder is [Monitoring Artist](https://github.com/monitoringartist)
 (**56538.307023 NVPS**):
```bash
$ docker exec -ti dockbix-agent-xxl zabbix_agent_bench -host 127.0.0.1 -key stress.ping[] -timelimit 10 -threads 128
Testing 1 keys with 128 threads (press Ctrl-C to cancel)...
stress.ping[] : 565506  0       0

=== Totals ===

Total values processed:         565506
Total unsupported values:       0
Total transport errors:         0
Total key list iterations:      565506

Finished! Processed 565506 values across 128 threads in 10.002174274s (56538.307023 NVPS)
```

# Rules

- use original Zabbix agent source codes/packages
- use `stress.ping[]` item provided by a [zabbix-agent-stress-test module](https://github.com/monitoringartist/zabbix-agent-stress-test)
- use [zabbix_agent_bench](https://github.com/cavaliercoder/zabbix_agent_bench)
 for benchmarking
- use `localhost/127.0.0.1` network interface
- use 10 seconds timelimit
- try to experiment with `StartAgents` and `-threads` settings to achieve the
highest NVPS score

The easy solution is to use Docker and
[dockbix-agent-xxl container](https://github.com/monitoringartist/dockbix-agent-xxl):

```bash
docker run \
  --name=dockbix-agent-xxl-nvps-challenge \
  --privileged \
  -v /:/rootfs \
  -v /var/run:/var/run \
  -e "ZA_Server=0.0.0.0/0" \
  -e "ZA_StartAgents=100" \
  -d monitoringartist/dockbix-agent-xxl-limited:latest

cat /proc/cpuinfo | grep "model name" | uniq -c
date
docker exec -t dockbix-agent-xxl-nvps-challenge zabbix_agent_bench -host 127.0.0.1 \
 -key stress.ping[] -timelimit 10 -threads 128
docker rm -f dockbix-agent-xxl-nvps-challenge
```

[Public Google Form](https://docs.google.com/forms/d/e/1FAIpQLSdRmBUnaie0ElvDfJ40bgUmhiccLgGSTWvHyDsBAgl_4JF-Zw/viewform) to submit your results manually.

# Performance table

Selected tested servers and achieved Zabbix agent NVPS score:

| NVPS | Server description |
| ---: | :----------------- |
| ~56k | 36 x Intel(R) Xeon(R) CPU E5-2666 v3 @ 2.90GHz; AWS EC2 c4.8xlarge |
| ~44k | 64 x Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz; AWS EC2 m4.16xlarge |
| ~8k  |  4 x Intel(R) Core(TM) i7-7500U CPU @ 2.70GHz |

[Public Google Sheet](https://drive.google.com/open?id=1qv5siZ-lGa69GnibsbtYHnCMdG05zrZG7L7FCuInF08) with all results.

# Author

[Devops Monitoring Expert](http://www.jangaraj.com 'DevOps / Docker / Kubernetes / AWS ECS / Google GCP / Zabbix / Zenoss / Terraform / Monitoring'),
who loves monitoring systems and cutting/bleeding edge technologies: Docker,
Kubernetes, ECS, AWS, Google GCP, Terraform, Lambda, Zabbix, Grafana, Elasticsearch,
Kibana, Prometheus, Sysdig,...

Summary:
* 2000+ [GitHub](https://github.com/monitoringartist/) stars
* 10 000+ [Grafana dashboard](https://grafana.net/monitoringartist) downloads
* 1 000 000+ [Docker image](https://hub.docker.com/u/monitoringartist/) pulls

Professional devops / monitoring / consulting services:

[![Monitoring Artist](http://monitoringartist.com/img/github-monitoring-artist-logo.jpg)](http://www.monitoringartist.com 'DevOps / Docker / Kubernetes / AWS ECS / Google GCP / Zabbix / Zenoss / Terraform / Monitoring')
