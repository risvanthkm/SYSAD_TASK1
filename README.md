# SYSAD_TASK1

A comprehensive system administration automation project featuring bash scripts for user management, resource monitoring, security enforcement, and gamified activity tracking.

## Overview

This repository contains a suite of shell scripts designed to manage a multi-tier user system with three distinct groups: **wardens** (administrators), **guards** (monitors), and **bashers** (restricted users). The system implements sophisticated logging, resource tracking, penalty mechanisms, and a competitive leaderboard system.

## Project Structure

### Scripts

- **`init.sh`** - Initialization script that sets up groups, sudo permissions, ACLs, and installs dependencies
- **`initRoster.sh`** - Creates and configures user accounts based on roster.yaml; sets up SSH keys, aliases, and restricted shells
- **`collectTax.sh`** - Monitors disk usage and removes oversized files from basher directories; logs activity to audit trail
- **`generateLore.sh`** - Background process that generates base64-encoded words and stores them in the vault
- **`verifyHeist.sh`** - Monitors Drop_Zone directories for encoded word files; triggers alerts when bashers successfully extract target words
- **`trendSetters.sh`** - Computes dynamic leaderboard scores based on activity, streaks, and time decay
- **`LPenalty.sh`** - Command audit and restriction enforcement; escalates users to restricted shell (`rbash`) if penalty threshold exceeded
- **`NoCapSecurity.sh`** - Creates symlink obfuscation layer pointing to random system directories; conceals real vault location
- **`secureVault.sh`** - Configures ACLs for the `/opt/Bashrot_vault` directory with group-based access control
- **`wipeTimeline.sh`** - Purges vault contents and user files; resets ACLs and re-secures the vault
- **`roster.yaml`** - Configuration file containing user definitions with SSH public keys and avatar URLs

## Key Features

### User Management
- Three-tier permission hierarchy (wardens > guards > bashers)
- Automated user creation with home directories, SSH key setup, and custom aliases
- Restricted shell (`rbash`) enforcement for policy violators

### Security & Auditing
- ACL-based access control with group granularity
- Command-level audit tracking via `LPenalty.sh` using bash DEBUG trap
- Sudo rule configuration for privilege escalation management

### Resource Monitoring
- Automated disk usage tracking and file removal
- Scheduled execution via crontab (every 5 minutes on weekends)
- Audit logging with file sizes and timestamps

### Gamification
- Activity-based scoring with streak multipliers
- Time-decay scoring algorithm
- Dynamic leaderboard with position tracking and movement indicators
- Word-stealing game mechanics via encoded file verification

### Obfuscation & Defense
- Symlink randomization to obscure vault location
- Base64 encoding for stored data
- Word filtering and replacement in content generation

## Group Permissions

| Group | Role | Capabilities |
|-------|------|--------------|
| **wardens** | Administrators | Full sudo access; read/execute on all scripts |
| **guards** | Monitors | Collect tax execution; read vault; leaderboard access |
| **bashers** | Restricted Users | Confined to limited bins; subject to command penalties; game participants |

## Installation & Setup

### Initial Setup

1. Place all files in the `/scripts/` directory
2. Run the initialization script:

```bash
sudo bash /scripts/init.sh
sudo bash /scripts/initRoster.sh
```

### Dependencies

The following tools are required and installed by `init.sh`:

- `yq` - YAML query processor
- `bc` - Calculator
- `base64` - Encoding/decoding utility
- `acl` - Access control list utilities
- `chafa` - Image-to-terminal renderer
- `curl` - Data transfer utility

## Scheduled Processes

The following services run automatically:

- **collectTax.sh** - Cron: `*/5 * * * 5-6` (Every 5 minutes on weekends)
- **generateLore.sh** - Background daemon (30-second intervals)
- **verifyHeist.sh** - Background daemon (60-second intervals)
- **trendSetters.sh** - (Typically run on-demand or via cron)
- **NoCapSecurity.sh** - Background daemon (45-minute intervals)

## Penalty System

The `LPenalty.sh` script monitors basher commands for restricted operations:

| Restricted Command | Penalty Points |
|--------------------|-----------------|
| `rm -rf /` | 1,000,000 |
| `rm -rf` | 800,000 |
| `chmod 777 /` | 900,000 |
| `chmod [0-7]* /` | 800,000 |
| `cd /home/wardens` | 300,000 |
| `ls /home/wardens` | 100,000 |
| `cat /home/wardens` | 100,000 |

**Threshold**: 2,912,008 points
**Consequence**: User is escalated to restricted bash shell (`rbash`) for 30 minutes, then restored

## Security Considerations

⚠️ **This system is designed as an educational/training project with intentional security mechanisms.**

- Users are confined via restricted shells and limited PATH
- All commands are logged and penalized if they violate policy
- Multiple layers of ACL enforcement separate privilege tiers
- Audit trails are protected from basher access
- Vault location is obfuscated through symlink randomization

## Files Reference

```
scripts/
├── collectTax.sh       # Tax collection and file removal
├── generateLore.sh     # Encoded word generation
├── init.sh             # System initialization
├── initRoster.sh       # User provisioning
├── LPenalty.sh         # Command penalty enforcement
├── NoCapSecurity.sh    # Symlink obfuscation
├── secureVault.sh      # Vault ACL configuration
├── slang.txt           # Word list for the game
├── trendSetters.sh     # Leaderboard computation
├── verifyHeist.sh      # Heist verification and logging
├── wipeTimeline.sh     # Vault and file cleanup
└── roster.yaml         # User roster configuration
```

## License

This project is provided as-is for educational purposes.
