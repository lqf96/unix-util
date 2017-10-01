#! /sbin/openrc-run
# The Tunnel Broker IPv6 service script

# Start kernel SIT tunnel
start_kernel() {
    ip tunnel add "${TB_INTERFACE}" mode sit remote "${TB_REMOTE_V4}" local "${TB_LOCAL_V4}" ttl 255
}

# Stop kernel SIT tunnel
stop_kernel() {
    ip tunnel del "${TB_INTERFACE}"
}

# Start userland daemon and TUN tunnel
start_user() {
    start-stop-daemon --start --quiet --background --pidfile "${TB_TUN_PID_FILE}" --make-pidfile \
        --exec "${TB_TUN_EXE}" -- "${TB_INTERFACE}" "${TB_REMOTE_V4}" "${TB_LOCAL_V4}" sit
    # Wait for 2 seconds before bringing up the interface
    sleep 2
}

# Stop userland daemon and TUN tunnel
stop_user() {
    start-stop-daemon --stop --quiet --pidfile "${TB_TUN_PID_FILE}"
}

# Start service
start() {
    ebegin "Starting IPv6 tunnel"
    # Mode-specific start work
    "start_${TB_MODE}"

    # Bring up the interface
    ip link set "${TB_INTERFACE}" up
    # Set IPv6 address for the interface
    ip -f inet6 addr add "${TB_LOCAL_V6}" dev "${TB_INTERFACE}"
    # Add IPv6 route
    ip -f inet6 route add ::/0 dev "${TB_INTERFACE}"

    # Service started
    eend 0
}

# Stop service
stop() {
    ebegin "Stopping IPv6 tunnel"

    # Remove IPv6 route
    ip -f inet6 route del ::/0 dev "${TB_INTERFACE}"
    # Bring down the interface
    ip link set "${TB_INTERFACE}" down

    # Mode-specific stop work
    "stop_${TB_MODE}"
    # Stop completed
    eend $?
}
