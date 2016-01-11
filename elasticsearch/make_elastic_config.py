"""Print out elasticsearch config lines for clustering.
Requests ip addresses of kuberdock pods from master,
set that ips for elastic zen.unicast cluster discovery.
Set host's IP as publish_host for elastic node.
The script uses following environment variables:
  MASTER - IP of kuberdock master host to retrieve list of nodes
  TOKEN - token for internal kuberdock user to get access to api server
  NODENAME - name of the current node to extract it's pod IP from unicast list
"""
import os

import requests

MASTER = os.environ.get('MASTER', 'master')
TOKEN = os.environ.get('TOKEN', '')
NODENAME = os.environ.get('NODENAME', '')

pods = requests.get(
    'https://{}/api/podapi?token={}'.format(MASTER, TOKEN),
    verify=False
).json()[u'data']

node_ip = None
cluster_ips = []

for pod in pods:
    name = pod[u'name']
    if not name.startswith(u'kuberdock-logs-'):
        continue
    if pod['status'] != 'running':
        continue

    hostname = pod[u'node']
    ip = pod[u'podIP']
    if hostname == NODENAME:
        node_ip = ip
        # skip self in unicast.hosts
        continue
    if ip:
        cluster_ips.append(ip)
    else:
        cluster_ips.append(hostname)

if node_ip:
   print('network.publish_host: {}'.format(node_ip))

print('discovery.zen.ping.multicast.enabled: false')
print('discovery.zen.ping.unicast.hosts: [{}]'.format(
    ', '.join('"{}"'.format(ip) for ip in cluster_ips))
)
