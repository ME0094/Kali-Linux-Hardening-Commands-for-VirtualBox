#!/bin/bash

# Kali Linux Hardening Script

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root" 
    exit
fi

echo "Starting Kali Linux Hardening Process..."

# 1. System Updates
echo "Updating system..."
apt update
apt upgrade -y
apt dist-upgrade -y
apt autoremove -y
apt autoclean

# 2. User Management
echo "Configuring user management..."
read -p "Enter a new username: " newuser
adduser $newuser
usermod -aG sudo $newuser
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# 3. Firewall Configuration
echo "Configuring firewall..."
apt install ufw -y
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw --force enable

# 4. SSH Hardening
echo "Hardening SSH..."
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/X11Forwarding yes/X11Forwarding no/' /etc/ssh/sshd_config
systemctl restart ssh

# 5. Disable Unnecessary Services
echo "Disabling unnecessary services..."
systemctl disable bluetooth.service
systemctl disable cups.service
systemctl disable avahi-daemon.service

# 6. File System Security
echo "Securing file system..."
chmod 700 /root
chmod 700 /home/*
chmod 700 /etc/ssh

# 7. Network Security
echo "Configuring network security..."
echo "net.ipv6.conf.all.disable_ipv6 = 1" | tee -a /etc/sysctl.conf
sysctl -p

# 8. Install and Configure fail2ban
echo "Installing and configuring fail2ban..."
apt install fail2ban -y
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
systemctl enable fail2ban
systemctl start fail2ban

# 9. Enable and Configure AppArmor
echo "Configuring AppArmor..."
apt install apparmor apparmor-utils -y
aa-enforce /etc/apparmor.d/*

# 10. Secure Shared Memory
echo "Securing shared memory..."
echo "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0" | tee -a /etc/fstab

# 11. Disable Core Dumps
echo "Disabling core dumps..."
echo "* hard core 0" | tee -a /etc/security/limits.conf
echo "fs.suid_dumpable = 0" | tee -a /etc/sysctl.conf
sysctl -p

# 12. Enable Process Accounting
echo "Enabling process accounting..."
apt install acct -y
touch /var/log/wtmp

# 13. Install and Configure Audit Daemon
echo "Installing and configuring audit daemon..."
apt install auditd -y
systemctl enable auditd
systemctl start auditd

echo "Kali Linux Hardening Process Completed!"
echo "Please review the changes and reboot your system."
