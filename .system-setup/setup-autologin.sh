#!/bin/bash

USERNAME=$(logname)
USER_HOME=$(eval echo "~$USERNAME")

echo "🔧 Настройка автологина для пользователя: $USERNAME"

# 1. Systemd override
mkdir -p /etc/systemd/system/getty@tty1.service.d

cat > /etc/systemd/system/getty@tty1.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USERNAME --noclear %I \$TERM
EOF

# 3. Применить изменения
systemctl daemon-reexec
systemctl restart getty@tty1

echo "✅ Автологин настроен для пользователя '$USERNAME'"

