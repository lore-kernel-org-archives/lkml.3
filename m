Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbaB0CRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:17:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33513 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaB0CQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:16:51 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] ARM: config: Add qcom_defconfig
Date: Wed, 26 Feb 2014 18:16:32 -0800
Message-Id: <1393467394-10907-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1393467394-10907-1-git-send-email-sboyd@codeaurora.org>
References: <1393467394-10907-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a defconfig for mach-qcom platforms. Although these platforms
are part of the multi-platform kernel, it's useful to have a
stripped down version of the defconfig that just selects the
Qualcomm based platforms and drivers.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/configs/qcom_defconfig | 139 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)
 create mode 100644 arch/arm/configs/qcom_defconfig

diff --git a/arch/arm/configs/qcom_defconfig b/arch/arm/configs/qcom_defconfig
new file mode 100644
index 000000000000..0e85031bf3c5
--- /dev/null
+++ b/arch/arm/configs/qcom_defconfig
@@ -0,0 +1,139 @@
+CONFIG_SYSVIPC=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_SYSCTL_SYSCALL=y
+CONFIG_KALLSYMS_ALL=y
+CONFIG_EMBEDDED=y
+# CONFIG_SLUB_DEBUG is not set
+# CONFIG_COMPAT_BRK is not set
+CONFIG_PROFILING=y
+CONFIG_OPROFILE=y
+CONFIG_KPROBES=y
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_MODULE_FORCE_UNLOAD=y
+CONFIG_MODVERSIONS=y
+CONFIG_PARTITION_ADVANCED=y
+CONFIG_ARCH_QCOM=y
+CONFIG_ARCH_MSM8X60=y
+CONFIG_ARCH_MSM8960=y
+CONFIG_ARCH_MSM8974=y
+CONFIG_SMP=y
+CONFIG_PREEMPT=y
+CONFIG_AEABI=y
+CONFIG_HIGHMEM=y
+CONFIG_HIGHPTE=y
+CONFIG_CLEANCACHE=y
+CONFIG_ARM_APPENDED_DTB=y
+CONFIG_ARM_ATAG_DTB_COMPAT=y
+CONFIG_VFP=y
+CONFIG_NEON=y
+# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+CONFIG_IP_ADVANCED_ROUTER=y
+CONFIG_IP_MULTIPLE_TABLES=y
+CONFIG_IP_ROUTE_VERBOSE=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_IPV6 is not set
+CONFIG_CFG80211=y
+CONFIG_RFKILL=y
+CONFIG_BLK_DEV_LOOP=y
+CONFIG_BLK_DEV_RAM=y
+CONFIG_SCSI=y
+CONFIG_SCSI_TGT=y
+CONFIG_BLK_DEV_SD=y
+CONFIG_CHR_DEV_SG=y
+CONFIG_CHR_DEV_SCH=y
+CONFIG_SCSI_MULTI_LUN=y
+CONFIG_SCSI_CONSTANTS=y
+CONFIG_SCSI_LOGGING=y
+CONFIG_SCSI_SCAN_ASYNC=y
+CONFIG_NETDEVICES=y
+CONFIG_DUMMY=y
+CONFIG_SLIP=y
+CONFIG_SLIP_COMPRESSED=y
+CONFIG_SLIP_MODE_SLIP6=y
+CONFIG_USB_USBNET=y
+# CONFIG_USB_NET_AX8817X is not set
+# CONFIG_USB_NET_ZAURUS is not set
+CONFIG_INPUT_EVDEV=y
+# CONFIG_KEYBOARD_ATKBD is not set
+# CONFIG_MOUSE_PS2 is not set
+CONFIG_INPUT_JOYSTICK=y
+CONFIG_INPUT_TOUCHSCREEN=y
+CONFIG_INPUT_MISC=y
+CONFIG_INPUT_UINPUT=y
+CONFIG_SERIO_LIBPS2=y
+# CONFIG_LEGACY_PTYS is not set
+CONFIG_SERIAL_MSM=y
+CONFIG_SERIAL_MSM_CONSOLE=y
+CONFIG_HW_RANDOM=y
+CONFIG_HW_RANDOM_MSM=y
+CONFIG_I2C=y
+CONFIG_I2C_CHARDEV=y
+CONFIG_SPI=y
+CONFIG_DEBUG_GPIO=y
+CONFIG_GPIO_SYSFS=y
+CONFIG_POWER_SUPPLY=y
+CONFIG_POWER_RESET=y
+CONFIG_POWER_RESET_MSM=y
+CONFIG_THERMAL=y
+CONFIG_REGULATOR=y
+CONFIG_MEDIA_SUPPORT=y
+CONFIG_FB=y
+CONFIG_SOUND=y
+CONFIG_SND=y
+CONFIG_SND_DYNAMIC_MINORS=y
+# CONFIG_SND_ARM is not set
+# CONFIG_SND_SPI is not set
+# CONFIG_SND_USB is not set
+CONFIG_SND_SOC=y
+CONFIG_HID_BATTERY_STRENGTH=y
+CONFIG_USB=y
+CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
+CONFIG_USB_MON=y
+CONFIG_USB_EHCI_HCD=y
+CONFIG_USB_EHCI_MSM=y
+CONFIG_USB_ACM=y
+CONFIG_USB_SERIAL=y
+CONFIG_USB_GADGET=y
+CONFIG_USB_GADGET_DEBUG_FILES=y
+CONFIG_USB_GADGET_VBUS_DRAW=500
+CONFIG_RTC_CLASS=y
+CONFIG_STAGING=y
+CONFIG_COMMON_CLK_QCOM=y
+CONFIG_MSM_GCC_8660=y
+CONFIG_MSM_MMCC_8960=y
+CONFIG_MSM_MMCC_8974=y
+CONFIG_MSM_IOMMU=y
+CONFIG_EXT2_FS=y
+CONFIG_EXT2_FS_XATTR=y
+CONFIG_EXT3_FS=y
+# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
+CONFIG_EXT4_FS=y
+CONFIG_FUSE_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_TMPFS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3_ACL=y
+CONFIG_NFS_V4=y
+CONFIG_CIFS=y
+CONFIG_PRINTK_TIME=y
+CONFIG_DYNAMIC_DEBUG=y
+CONFIG_DEBUG_INFO=y
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_LOCKUP_DETECTOR=y
+# CONFIG_DETECT_HUNG_TASK is not set
+# CONFIG_SCHED_DEBUG is not set
+CONFIG_TIMER_STATS=y
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

