Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab3KMPGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:06:52 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:44271 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759318Ab3KMPGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:06:51 -0500
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: linux-kernel@vger.kernel.org
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH] ARC: [plat-arcfpga] Add defconfig without initramfs location
Date: Wed, 13 Nov 2013 16:06:36 +0100
Message-Id: <1384355196-21462-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful if you want to build a kernel without a ramfs, or
if you want to test the kernel build without having an initramfs
available at the hardcoded location.

Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
---
 arch/arc/configs/fpga_noramfs_defconfig |   64 +++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 arch/arc/configs/fpga_noramfs_defconfig

diff --git a/arch/arc/configs/fpga_noramfs_defconfig b/arch/arc/configs/fpga_noramfs_defconfig
new file mode 100644
index 0000000..5276a52
--- /dev/null
+++ b/arch/arc/configs/fpga_noramfs_defconfig
@@ -0,0 +1,64 @@
+CONFIG_CROSS_COMPILE="arc-linux-uclibc-"
+# CONFIG_LOCALVERSION_AUTO is not set
+CONFIG_DEFAULT_HOSTNAME="ARCLinux"
+# CONFIG_SWAP is not set
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_NAMESPACES=y
+# CONFIG_UTS_NS is not set
+# CONFIG_PID_NS is not set
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_KALLSYMS_ALL=y
+CONFIG_EMBEDDED=y
+# CONFIG_SLUB_DEBUG is not set
+# CONFIG_COMPAT_BRK is not set
+CONFIG_KPROBES=y
+CONFIG_MODULES=y
+# CONFIG_LBDAF is not set
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+# CONFIG_IOSCHED_CFQ is not set
+CONFIG_ARC_PLAT_FPGA_LEGACY=y
+CONFIG_ARC_BOARD_ML509=y
+# CONFIG_ARC_HAS_RTSC is not set
+CONFIG_ARC_BUILTIN_DTB_NAME="angel4"
+CONFIG_PREEMPT=y
+# CONFIG_COMPACTION is not set
+# CONFIG_CROSS_MEMORY_ATTACH is not set
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_UNIX_DIAG=y
+CONFIG_NET_KEY=y
+CONFIG_INET=y
+# CONFIG_IPV6 is not set
+# CONFIG_STANDALONE is not set
+# CONFIG_PREVENT_FIRMWARE_BUILD is not set
+# CONFIG_FIRMWARE_IN_KERNEL is not set
+# CONFIG_BLK_DEV is not set
+CONFIG_NETDEVICES=y
+CONFIG_ARC_EMAC=y
+CONFIG_LXT_PHY=y
+# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_SERIO is not set
+# CONFIG_LEGACY_PTYS is not set
+# CONFIG_DEVKMEM is not set
+CONFIG_SERIAL_ARC=y
+CONFIG_SERIAL_ARC_CONSOLE=y
+# CONFIG_HW_RANDOM is not set
+# CONFIG_HWMON is not set
+# CONFIG_VGA_CONSOLE is not set
+# CONFIG_HID is not set
+# CONFIG_USB_SUPPORT is not set
+# CONFIG_IOMMU_SUPPORT is not set
+CONFIG_EXT2_FS=y
+CONFIG_EXT2_FS_XATTR=y
+CONFIG_TMPFS=y
+# CONFIG_MISC_FILESYSTEMS is not set
+CONFIG_NFS_FS=y
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
+# CONFIG_ENABLE_MUST_CHECK is not set
+CONFIG_XZ_DEC=y
-- 
1.7.9.5

