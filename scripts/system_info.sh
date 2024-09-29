#!/bin/bash

# Display system uptime
echo "System Uptime:"; uptime -p; echo

# Display CPU usage
echo "CPU Usage:"; top -bn1 | grep "Cpu(s)" | awk '{printf("  Usage: %.2f%%\n", 100 - $8)}'; echo

# Display memory usage
echo "Memory Usage:"; free -h | awk 'NR==2{printf("  Used: %s / Total: %s (%.2f%%)\n", $3, $2, $3*100/$2)}'; echo

# Display top running processes
echo "Running Processes:"; ps aux --sort=-%mem | awk 'NR<=10{printf("  %s: %s (PID: %d)\n", $1, $11, $2)}'
