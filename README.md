# SYSAD_TASK1

*A system administration automation project containing Bash scripts for managing users, groups, permissions, creating vulnerabilities, penalty mechanisms, and calculating dynamic player scores.*

![Bash](https://img.shields.io/badge/Bash-121011?style=for-the-badge&logo=gnubash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![User Management](https://img.shields.io/badge/User%20Management-00599C?style=for-the-badge&logo=linux&logoColor=white)
![Permissions](https://img.shields.io/badge/File%20Permissions-4CAF50?style=for-the-badge&logo=gnubash&logoColor=white)
![YAML](https://img.shields.io/badge/YAML-CB171E?style=for-the-badge&logo=yaml&logoColor=white)
![yq](https://img.shields.io/badge/yq-009688?style=for-the-badge&logo=yaml&logoColor=white)
![curl](https://img.shields.io/badge/curl-073551?style=for-the-badge&logo=curl&logoColor=white)
![sed](https://img.shields.io/badge/sed-555555?style=for-the-badge&logo=gnubash&logoColor=white)
![awk](https://img.shields.io/badge/awk-6E4C13?style=for-the-badge&logo=gnubash&logoColor=white)
![grep](https://img.shields.io/badge/grep-FF6F00?style=for-the-badge&logo=gnubash&logoColor=white)
![find](https://img.shields.io/badge/find-607D8B?style=for-the-badge&logo=linux&logoColor=white)
![Cron](https://img.shields.io/badge/Cron-3F51B5?style=for-the-badge&logo=linux&logoColor=white)
![chafa](https://img.shields.io/badge/chafa-Terminal%20Graphics-FF6B35?style=for-the-badge&logo=gnubash&logoColor=white)
![ACL](https://img.shields.io/badge/ACL-Access%20Control%20Lists-1976D2?style=for-the-badge&logo=linux&logoColor=white)
![Base64](https://img.shields.io/badge/Base64-Encoding-4CAF50?style=for-the-badge&logo=gnubash&logoColor=white)
![Regex](https://img.shields.io/badge/Regex-Regular%20Expressions-8E44AD?style=for-the-badge)
![SSH](https://img.shields.io/badge/SSH-OpenSSH-111111?style=for-the-badge&logo=openssh&logoColor=white)
![Sudo](https://img.shields.io/badge/Sudo-Privilege%20Management-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![rbash](https://img.shields.io/badge/rbash-Restricted%20Shell-8B0000?style=for-the-badge&logo=gnubash&logoColor=white)
![Symlink](https://img.shields.io/badge/Symlink-Obfuscation-795548?style=for-the-badge)
![ASCII Art](https://img.shields.io/badge/ASCII-Art-00BCD4?style=for-the-badge)

---

## Project Structure

### Scripts

- **`init.sh`** - Initialization script that sets up groups, permissions for each group, ACLs, and installs dependencies.
- **`initRoster.sh`** - Creates, deletes, and configures user accounts dynamically based on `roster.yaml`, sets up SSH keys, aliases, and `.avatar.txt`.
- **`secureVault.sh`** - Configures ACLs for the `/opt/Bashrot_vault` directory with group-based access control and creates an intentional vulnerability inside the vault.
- **`generateLore.sh`** - Background process that filters bad words using `sed`, generates Base64-encoded words, and stores them in the vault.
- **`collectTax.sh`** - Monitors disk usage by bashers, removes oversized files from basher directories, and logs activity.
- **`verifyHeist.sh`** - Monitors `Drop_Zone` directories of bashers for encoded word files and alerts all users when bashers successfully extract target words from the vault.
- **`trendSetters.sh`** - Computes dynamic leaderboard scores based on streak, clutch, and decay factors.
- **`wipeTimeline.sh`** - Removes vault contents and basher files without affecting the directory, resets ACLs, and recreates the vault.
- **`LPenalty.sh`** - Monitors harmful commands executed by bashers and demotes users to a restricted shell (`rbash`) if the penalty threshold is exceeded.
- **`NoCapSecurity.sh`** - Creates **6,767** symbolic links pointing to random system locations, where only one symlink resolves to the encoded file.
- **`roster.yaml`** - Configuration file used for automated user creation.

---

## Key Features

### User Management

- Three groups with hierarchy (`wardens` > `guards` > `bashers`)
- Automated user creation with home directories, SSH key setup, custom aliases, and avatars using `yq`
- Downloads user avatars using `curl` and converts them into ASCII art using `chafa`

### Security

- ACL - access control based on groups
- Harmful command tracking via `LPenalty.sh` using the Bash `DEBUG` trap
- Random Symlink generation to conceal the encoded text file location
- Base64 encoding for stored data
- Restricted shell (`rbash`) enforcement for bashers who execute harmful commands (exceeding a threshold)

### Resource Monitoring

- Automated monitoring of basher directory disk usage with removal of files exceeding **5 MB**
- Scheduled execution via cron every **5 minutes on weekends**
- Logging with file sizes and timestamps
- Prevents `.bashrc` and `.avatar.txt` from being deleted

### Leaderboard

- Activity-based scoring using streak, decay, and clutch factors
- Dynamic leaderboard with position deltas and the score
- Used bc for carrying out complex calculations

---

## Installation & Setup

### Initial Setup

1. Place all files in the `/scripts/` directory.
2. Run the initialization scripts:

```bash
sudo bash /scripts/init.sh
sudo bash /scripts/initRoster.sh
```

### Dependencies

The following tools are required and installed by `init.sh`:

- `yq` - YAML query processor
- `bc` - Calculator
- `base64` - Encoding/decoding utility
- `acl` - Access Control List utilities
- `chafa` - Image-to-terminal renderer
- `curl` - Data transfer utility

---

## Scheduled Processes

The following services run automatically:

- **`collectTax.sh`** - Cron: `*/5 * * * 5-6` (Every 5 minutes on weekends)
- **`generateLore.sh`** - Background process (30-second interval)
- **`verifyHeist.sh`** - Background process (60-second interval)
- **`NoCapSecurity.sh`** - Background process (45-minute interval)

---

## File Structure

```text
scripts/
├── collectTax.sh       # Enforce tax and file removal
├── generateLore.sh     # Encoded word generation
├── init.sh             # System initialization
├── initRoster.sh       # Automatic user creation
├── LPenalty.sh         # Montitors the bashers commands
├── NoCapSecurity.sh    # Generates symlinks to conceal the real encoded file
├── secureVault.sh      # Vault ACL configuration
├── slang.txt           # List of words
├── trendSetters.sh     # Leaderboard Calculation
├── verifyHeist.sh      # Heist verification and alerting 
├── wipeTimeline.sh     # Vault and file cleanup
└── roster.yaml         # User configuration file
```
