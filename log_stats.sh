#!/bin/bash
# log_stats.sh
echo "Timestamp,Container,Name,CPU %,MemUsage,Mem %,NetIO,BlockIO" > docker_stats.csv
while true; do
  date +%Y-%m-%dT%H:%M:%S | tr -d '\n' >> docker_stats.csv
  docker stats --no-stream --format ",{{.Container}},{{.Name}},{{.CPUPerc}},{{.MemUsage}},{{.MemPerc}},{{.NetIO}},{{.BlockIO}}" >> docker_stats.csv
  sleep 5
done
