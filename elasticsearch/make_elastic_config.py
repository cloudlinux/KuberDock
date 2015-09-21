"""Print out elasticsearch config lines for clustering.
Requests ip addresses of kuberdock nodes from master,
set that ips for elastic zen.unicast cluster discovery.
Set host's IP as publish_host for elastic node.
The script uses following environment variables:
  MASTER - IP of kuberdock master host to retrieve list of nodes
  TOKEN - token for kuberdock user to get access to api server
  NODENAME - name of the current node to extract it's host IP from nodes list
"""
import os

import requests

MASTER = os.environ.get('MASTER', 'master')
TOKEN = os.environ.get('TOKEN', '')
NODENAME = os.environ.get('NODENAME', '')

nodes = requests.get(
    'https://{}:6443/api/v1/nodes'.format(MASTER),
    headers={'Authorization': 'Bearer {}'.format(TOKEN)},
    verify=False
).json()['items']

# There may be several address types in the node's addresses list. We need only
# internal IPs. If there is no such IP, then try to get LegacyHostIP, as
# a fallback for non-cloud environments.
IP_PRIORITY = ['InternalIP', 'LegacyHostIP']

node_ip = None
cluster_ips = []

for node in nodes:
    hostname = node['metadata']['labels']['kuberdock-node-hostname']
    ip = None
    addresses = node.get('status', {}).get('addresses', [])
    addresses = {item['type']: item['address'] for item in addresses}
    for key in IP_PRIORITY:
        if key in addresses:
            ip = addresses[key]
            break

    if hostname == NODENAME:
        node_ip = ip
        # skip the node in unicast.hosts
        continue
    if ip:
        cluster_ips.append(ip)
    else:
        cluster_ips.append(hostname)

# Uncomment following 2 lines to allow publishing elastic host as IP of the
# node. At the moment a container has no access to itself via node's IP (it's
# blocked by iptables rules)
# if node_ip:
#    print('network.publish_host: {}'.format(node_ip))

print('discovery.zen.ping.multicast.enabled: false')
print('discovery.zen.ping.unicast.hosts: [{}]'.format(
    ', '.join('"{}"'.format(ip) for ip in cluster_ips))
)
