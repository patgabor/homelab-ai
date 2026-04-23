# Network Architecture: NetBird Routing & Private DNS Integration

> **⚠️ IMPORTANT: Arch-Based Linux Only**
> This project and all documentation are designed exclusively for **Arch-based Linux distributions** (e.g., Arch Linux, Manjaro, EndeavourOS). Other distributions are not supported.

This document outlines the technical configuration and traffic flow for a remote client accessing a private **K3s HA Cluster** via a NetBird Network Router.

## 1. Network Components

| Component | Role | IP Address |
| :--- | :--- | :--- |
| **Remote Client** | External workstation running NetBird Agent | Dynamic (VPN Assigned) |
| **Routing Peer** | K3s Node acting as a Subnet Gateway | 192.168.255.x |
| **DNS Server** | Internal resolver for `*.home.arpa` | 192.168.255.2 |
| **Target API** | Private service within the cluster | 192.168.255.5 |

## 2. Traffic Flow Logic

The system utilizes **Split-Tunneling**, ensuring the remote client maintains access to its local physical network while securely reaching the remote private infrastructure.

### A. Local Network Traffic

Traffic destined for the internet or devices on the client's physical network (e.g., local printers, local gateway) stays on the local interface. It does **not** enter the VPN tunnel.

### B. DNS Resolution Path

1. The user requests `*.home.arpa`.
2. NetBird identifies the `home.arpa` suffix based on the "Match Domains" configuration.
3. The query is forwarded specifically to the internal DNS server (`192.168.255.2`) via the encrypted tunnel.
4. The DNS server returns the internal IP: `192.168.255.5`.

### C. Private Subnet Routing

| Private Range | CIDR | Size | Typical Use |
| --- | --- | --- | --- |
| **10.0.0.0 – 10.255.255.255** | /8 | Very large | Enterprise networks |
| **172.16.0.0 – 172.31.255.255** | /12 | Medium | Corporate networks |
| **192.168.0.0 – 192.168.255.255** | /16 | Small | Home routers |

1. The client initiates a connection to `192.168.255.5`.
2. NetBird recognizes the `192.168.255.0/24` route defined in the management console.
3. The traffic is encrypted and sent to the **Routing Peer** on the K3s cluster.
4. The Routing Peer forwards the traffic to the API server and manages the return path.

## 3. Visual Infrastructure Map

```text
[ Remote Workstation ]
          |
    (NetBird Agent)
    /             \
[ Local LAN ]    [ Encrypted Tunnel ]
(Internet/Web)            |
                  [ K3s Routing Peer ]
                          |
              -------------------------
              |                       |
        [ DNS Server ]          [ API Service ]
        192.168.255.2           192.168.255.5
```

## 4. Configuration Requirements

To maintain stability and reachability, the following settings must be verified in the NetBird Dashboard:
Network Route: Define 192.168.255.0/24 with the K3s node as the designated routing peer.
Masquerade: Enabled. This ensures the API server sees traffic as coming from the K3s node's internal IP, preventing asynchronous routing issues.
Nameservers: Add 192.168.255.2 as a Nameserver with the "Match Domains" filter set to home.arpa.

## 5. Potential Conflicts

Critical Warning: Ensure the remote site's physical network does not use the 192.168.255.0/24 range. In the event of a subnet overlap, the operating system will prioritize the local physical route over the VPN tunnel, making the remote API unreachable.
