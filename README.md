# 🛡️ Kali Linux Hardening Guide

<p align="center">
  <img src="https://www.kali.org/images/kali-dragon-icon.svg" alt="Kali Linux Logo" width="200"/>
</p>

<p align="center">
  <a href="https://www.kali.org/"><img src="https://img.shields.io/badge/Platform-Kali%20Linux-557C94.svg"></a>
  <a href="https://www.gnu.org/licenses/gpl-3.0"><img src="https://img.shields.io/badge/License-GPLv3-blue.svg"></a>
  <a href="#"><img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg"></a>
</p>

## 📚 Table of Contents
1. [Introduction](#-introduction)
2. [Quick Start](#-quick-start)
3. [Detailed Hardening Steps](#-detailed-hardening-steps)
4. [Additional Resources](#-additional-resources)
5. [Contributing](#-contributing)
6. [License](#-license)

## 🔒 Introduction
This guide provides a comprehensive set of best practices and commands for hardening Kali Linux, a powerful penetration testing and security auditing platform. By following these steps, you can significantly enhance the security of your Kali Linux system, making it more resilient against potential vulnerabilities and attacks.

## 🚀 Quick Start
To quickly harden your Kali Linux system, you can use our automated script:

```bash
wget https://github.com/ME0094/Kali-Linux-Hardening-Commands-for-VirtualBox/blob/main/harden_kali.sh
chmod +x harden_kali.sh
sudo ./harden_kali.sh
```

⚠️ **Warning**: Always review scripts before running them with sudo privileges.

## 📋 Detailed Hardening Steps

### 1. System Updates
```bash
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt autoclean
```

### 2. User Management
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

### 3. Firewall Configuration
```bash
sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable
```

### 4. SSH Hardening
```bash
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/X11Forwarding yes/X11Forwarding no/' /etc/ssh/sshd_config
sudo systemctl restart ssh
```

# 5. Disable Unnecessary Services
```
sudo systemctl disable bluetooth.service
sudo systemctl disable cups.service
sudo systemctl disable avahi-daemon.service
```

# 6. File System Security
# Set proper permissions for important directories
```
sudo chmod 700 /root
sudo chmod 700 /home/*
sudo chmod 700 /etc/ssh
```

# 7. Network Security
# Disable IPv6 if not needed
```
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

# 8. VirtualBox-specific Settings
# Disable Shared Folders if not needed
```
VBoxManage setextradata "Kali Linux" VBoxInternal2/SharedFoldersEnableSymlinksCreate/sharename 0
```

# Disable Clipboard Sharing
```
VBoxManage modifyvm "Kali Linux" --clipboard-mode disabled
```

# Disable Drag and Drop
```
VBoxManage modifyvm "Kali Linux" --draganddrop disabled
```


# 9. Install and Configure fail2ban
```
sudo apt install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

# 10. Enable and Configure AppArmor
```
sudo apt install apparmor apparmor-utils -y
sudo aa-enforce /etc/apparmor.d/*
```

# 11. Secure Shared Memory
```
echo "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0" | sudo tee -a /etc/fstab
```

# 12. Disable Core Dumps
```
echo "* hard core 0" | sudo tee -a /etc/security/limits.conf
echo "fs.suid_dumpable = 0" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

# 13. Secure GRUB Bootloader
```
sudo update-grub
sudo grub-mkpasswd-pbkdf2
# Follow the prompts to create a password hash, then add it to /etc/grub.d/40_custom:
# set superusers="admin"
# password_pbkdf2 admin <generated-password-hash>
sudo update-grub
```

# 14. Enable Process Accounting
```
sudo apt install acct -y
sudo touch /var/log/wtmp
```

# 15. Install and Configure Audit Daemon
```
sudo apt install auditd -y
sudo systemctl enable auditd
sudo systemctl start auditd
```

## 📚 Additional Resources
- [Official Kali Linux Documentation](https://www.kali.org/docs/)
- [Linux Server Hardening Guide](https://github.com/imthenachoman/How-To-Secure-A-Linux-Server)
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)

## 🤝 Contributing
Contributions to this hardening guide are welcome! Please submit a pull request or open an issue to suggest improvements or additions.

## 📄 License
This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer
This guide is provided as-is, without any warranties. Always test these hardening measures in a controlled environment before applying them to production systems.

Remember to reboot your system after applying these changes:
```bash
sudo reboot
```
