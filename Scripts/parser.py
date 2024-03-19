import sys
from libnmap.parser import NmapParser
filename = sys.argv[1]
p = NmapParser.parse_fromfile(filename)
for host in p.hosts:
 for svc in host.services:
  for script in svc.scripts_results:
   output = script.get("output")
   print(output)
