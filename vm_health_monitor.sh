#!/bin/bash
# vm_health_monitor.sh - Monitor VM CPU, disk, and memory usage

# Get CPU usage (average over 1 minute)
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
cpu_percent=$(printf "%.0f" "$cpu_usage")

# Get memory usage percentage
mem_total=$(free | grep Mem | awk '{print $2}')
mem_used=$(free | grep Mem | awk '{print $3}')
mem_percent=$((mem_used * 100 / mem_total))

# Get disk usage percentage (root partition)
disk_percent=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

# Health check logic
if [ "$cpu_percent" -gt 30 ] || [ "$mem_percent" -gt 30 ] || [ "$disk_percent" -gt 30 ]; then
    health="Not Healthy"
else
    health="Healthy"
fi

# Command line interpreter for explanation
if [ "$1" == "explain" ]; then
    echo "CPU usage: $cpu_percent%"
    echo "Memory usage: $mem_percent%"
    echo "Disk usage: $disk_percent%"
    if [ "$health" == "Not Healthy" ]; then
        echo "Status: Not Healthy - One or more resources exceed 30% utilization."
    else
        echo "Status: Healthy - All resources are below 30% utilization."
    fi
else
    echo "VM Health Status: $health"
fi
