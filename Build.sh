#!/bin/bash

# 1. منع أي واجهة رسومية من طلب إدخال بيانات (صامت تماماً)
export DEBIAN_FRONTEND=noninteractive

echo "🚀 Starting Full Auto-Build..."

# 2. تحديث المستودعات (مع تجاهل الأخطاء البسيطة)
sudo apt-get update -y || true

# 3. تثبيت الأساسيات (XFCE, Yaru, Wine, Waydroid)
# لاحظ وجود -y و --force-yes و --fix-missing لضمان عدم التوقف
sudo apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    xubuntu-desktop yaru-theme-gtk yaru-theme-icon zram-config \
    waydroid winehq-staging htop plymouth-theme-ubuntu-logo \
    xfce4-docklike-plugin synaptic --fix-missing || true

# 4. إضافة مستودع MX Tools وتثبيته أوتوماتيكياً
# أداة "yes" هنا وظيفتها تضغط Enter بدالك لو الـ PPA سأل عن تأكيد
yes "" | sudo add-apt-repository ppa:mx-linux/mx-tools -y || true
sudo apt-get update -y || true
sudo apt-get install -y mx-apps mx-tools || true

# 5. تظبيط الـ Double Click (APK, EXE, MSI)
# السطر ده بيعمل الاختصارات من غير ما يسأل حد
sudo mkdir -p x/usr/share/applications/
sudo bash -c 'cat <<EOF > x/usr/share/applications/waydroid-install.desktop
[Desktop Entry]
Type=Application
Name=Install APK
Exec=waydroid app install %f
Icon=android-sdk
MimeType=application/vnd.android.package-archive;
EOF' || true

# 6. Performance Tweaks (ZRAM & Swappiness)
# حقن الإعدادات مباشرة في الملفات
echo "ALGO=lz4" | sudo tee -a x/etc/default/zramswap || true
echo "vm.swappiness=150" | sudo tee -a x/etc/sysctl.conf || true

# 7. تفعيل ثيم أوبونتو (الـ Plymouth)
# استخدام --force عشان يوافق على التغيير فوراً
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.plymouth 100 || true
sudo update-alternatives --set default.plymouth /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.plymouth || true

# 8. مسح الـ Snap (التقيل) ومنع تحديثات الخلفية
sudo apt-get purge -y snapd unattended-upgrades || true

echo "✅ All commands executed automatically!"
