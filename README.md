# 🛡️ Kali Linux Hardening Guide for VirtualBox

<p align="center">
 <img alt="Kali Linux Logo" src="https://www.kali.org/images/kali-dragon-icon.svg" width="200"/>
</p>

<p align="center">
 <a href="https://www.kali.org/"><img src="https://img.shields.io/badge/Platform-Kali%20Linux-557C94.svg"/></a>
 <a href="https://www.gnu.org/licenses/gpl-3.0"><img src="https://img.shields.io/badge/License-GPLv3-blue.svg"/></a>
 <a href="#"><img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg"/></a>
</p>

## 📚 Table of Contents
1. [Introduction](#-introduction)
2. [Prerequisites](#-prerequisites)
3. [Quick Start](#-quick-start)
4. [Detailed Hardening Steps](#-detailed-hardening-steps)
   - [System Updates](#1-system-updates)
   - [User Management](#2-user-management)
   - [Firewall Configuration](#3-firewall-configuration)
   - [SSH Hardening](#4-ssh-hardening)
   - [Disable Unnecessary Services](#5-disable-unnecessary-services)
   - [File System Security](#6-file-system-security)
   - [Network Security](#7-network-security)
   - [VirtualBox-specific Settings](#8-virtualbox-specific-settings)
   - [Install and Configure fail2ban](#9-install-and-configure-fail2ban)
   - [Enable and Configure AppArmor](#10-enable-and-configure-apparmor)
   - [Secure Shared Memory](#11-secure-shared-memory)
   - [Disable Core Dumps](#12-disable-core-dumps)
   - [Secure GRUB Bootloader](#13-secure-grub-bootloader)
   - [Enable Process Accounting](#14-enable-process-accounting)
   - [Install and Configure Audit Daemon](#15-install-and-configure-audit-daemon)
5. [Best Practices](#-best-practices)
6. [Troubleshooting](#-troubleshooting)
7. [Additional Resources](#-additional-resources)
8. [Contributing](#-contributing)
9. [License](#-license)
10. [Disclaimer](#-disclaimer)

## 🔒 Introduction

Welcome to the Kali Linux Hardening Guide for VirtualBox! This comprehensive guide provides a set of best practices and commands to enhance the security of your Kali Linux system running in VirtualBox. By following these steps, you can significantly improve your system's resilience against potential vulnerabilities and attacks, making it a more secure environment for penetration testing and security auditing.

Whether you're a cybersecurity professional, ethical hacker, or enthusiast, this guide will help you create a more robust Kali Linux setup, tailored specifically for use within VirtualBox.

## 🔧 Prerequisites

Before you begin, ensure you have:

- A working Kali Linux installation in VirtualBox
- Administrative (sudo) access to your Kali Linux system
- Basic familiarity with Linux command-line operations
- A stable internet connection for downloading updates and packages

## 🚀 Quick Start

To quickly harden your Kali Linux system, you can use our automated script:

```bash
wget https://github.com/ME0094/Kali-Linux-Hardening-Commands-for-VirtualBox/blob/main/harden_kali.sh
chmod +x harden_kali.sh
sudo ./harden_kali.sh
```

⚠️ **Warning**: Always review scripts before running them with sudo privileges. Security is about trust, and you should understand what you're executing on your system.

## 📋 Detailed Hardening Steps

### 1. System Updates

Keeping your system up-to-date is crucial for security. Run these commands to update your Kali Linux:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt autoclean
```

These commands update the package lists, upgrade installed packages, perform distribution upgrades, remove unnecessary packages, and clean the local repository of retrieved package files.

### 2. User Management

Proper user management is essential for system security:

```bash
# Change root password
sudo passwd root

# Create a new non-root user
sudo adduser newuser
sudo usermod -aG sudo newuser

# Disable root login via SSH
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart ssh
```

These steps change the root password, create a new user with sudo privileges, and disable root login via SSH for improved security.

### 3. Firewall Configuration

Configure the Uncomplicated Firewall (UFW) to control incoming and outgoing traffic:

```bash
sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable
```

This setup installs UFW, sets default policies, allows SSH connections, and enables the firewall.

### 4. SSH Hardening

Enhance SSH security with these configurations:

```bash
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/X11Forwarding yes/X11Forwarding no/' /etc/ssh/sshd_config
sudo systemctl restart ssh
```

These changes disable password authentication (use key-based authentication instead) and disable X11 forwarding for SSH connections.

### 5. Disable Unnecessary Services

Reduce potential attack surfaces by disabling unused services:

```bash
sudo systemctl disable bluetooth.service
sudo systemctl disable cups.service
sudo systemctl disable avahi-daemon.service
```

This disables Bluetooth, printing services, and Avahi (if not needed).

### 6. File System Security

Set proper permissions for important directories:

```bash
sudo chmod 700 /root
sudo chmod 700 /home/*
sudo chmod 700 /etc/ssh
```

These commands restrict access to sensitive directories.

### 7. Network Security

Disable IPv6 if not needed:

```bash
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

This step disables IPv6, which can help reduce potential attack vectors if you're not using it.

### 8. VirtualBox-specific Settings

Adjust VirtualBox settings for enhanced security:

```bash
# Disable Shared Folders if not needed
VBoxManage setextradata "Kali Linux" VBoxInternal2/SharedFoldersEnableSymlinksCreate/sharename 0

# Disable Clipboard Sharing
VBoxManage modifyvm "Kali Linux" --clipboard-mode disabled

# Disable Drag and Drop
VBoxManage modifyvm "Kali Linux" --draganddrop disabled
```

These commands enhance isolation between the host and guest systems.

### 9. Install and Configure fail2ban

fail2ban helps protect against brute-force attacks:

```bash
sudo apt install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

This installs and activates fail2ban with default settings.

### 10. Enable and Configure AppArmor

AppArmor provides Mandatory Access Control (MAC) security:

```bash
sudo apt install apparmor apparmor-utils -y
sudo aa-enforce /etc/apparmor.d/*
```

This enables and enforces AppArmor profiles for enhanced system security.

### 11. Secure Shared Memory

Protect shared memory from potential exploits:

```bash
echo "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0" | sudo tee -a /etc/fstab
```

This command mounts shared memory with restrictive flags.

### 12. Disable Core Dumps

Prevent sensitive information leaks through core dumps:

```bash
echo "* hard core 0" | sudo tee -a /etc/security/limits.conf
echo "fs.suid_dumpable = 0" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

These settings disable core dumps system-wide.

### 13. Secure GRUB Bootloader

Protect your bootloader with a password:

```bash
sudo update-grub
sudo grub-mkpasswd-pbkdf2
# Follow the prompts to create a password hash, then add it to /etc/grub.d/40_custom:
# set superusers="admin"
# password_pbkdf2 admin <generated-password-hash>
sudo update-grub
```

This secures the GRUB bootloader with a password, preventing unauthorized modifications to boot parameters.

### 14. Enable Process Accounting

Track system resource usage and user activities:

```bash
sudo apt install acct -y
sudo touch /var/log/wtmp
```

This enables process accounting for improved system auditing.

### 15. Install and Configure Audit Daemon

Set up system auditing for enhanced monitoring:

```bash
sudo apt install auditd -y
sudo systemctl enable auditd
sudo systemctl start auditd
```

This installs and activates the audit daemon for comprehensive system auditing.

## 💡 Best Practices

- Regularly update and patch your system
- Use strong, unique passwords for all accounts
- Implement two-factor authentication where possible
- Regularly review and remove unnecessary software and services
- Keep your VirtualBox software up-to-date
- Use encrypted communications whenever possible
- Regularly backup your data and configurations

## 🔍 Troubleshooting

If you encounter issues after applying these hardening measures:

1. Check system logs: `sudo journalctl -xe`
2. Verify service status: `sudo systemctl status <service-name>`
3. Review firewall rules: `sudo ufw status verbose`
4. Check SSH configurations: `sudo sshd -T`

If problems persist, consider reverting the last change made and seeking help from the Kali Linux community forums.

## 📚 Additional Resources

- [Official Kali Linux Documentation](https://www.kali.org/docs/)
- [Linux Server Hardening Guide](https://github.com/imthenachoman/How-To-Secure-A-Linux-Server)
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [VirtualBox Manual](https://www.virtualbox.org/manual/)
- [Kali Linux Forums](https://forums.kali.org/)

## 🤝 Contributing

We welcome contributions to this hardening guide! Here's how you can help:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/AmazingFeature`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
5. Push to the branch (`git push origin feature/AmazingFeature`)
6. Open a Pull Request

Please ensure your contributions align with the project's coding standards and include appropriate documentation.

## 📄 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This guide is provided as-is, without any warranties. Always test these hardening measures in a controlled environment before applying them to production systems. The authors are not responsible for any damage or data loss resulting from the use of this guide.

Remember to reboot your system after applying these changes:

```bash
sudo reboot
```

Stay secure! 🔐
