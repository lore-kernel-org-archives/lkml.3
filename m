Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab3AXLUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:20:09 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:47398 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab3AXLKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:10:45 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 36/71] ARC: [plat-arcfpga] defconfig
Date: Thu, 24 Jan 2013 16:36:04 +0530
Message-ID: <1359025589-22277-21-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this we get to a running kernel on ISS

---------------------------------->8-----------------------------------
Linux version 3.8.0-rc3+ (vineetg@vineetg-Latitude) (gcc version 4.4.7
(ARCompact elf32 toolchain (built 20121213)) ) #3 Thu Jan 17 14:22:05
IST 2013
Board "arc-angel4" from snps (Manufacturer)
Memory size set via devicetree 256M
[plat-arcfpga]: registering early dev resources
bootconsole [early_ARCuart0] enabled
pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
pcpu-alloc: [0] 0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
32624
Kernel command line: console=ttyARC0,115200n8
PID hash table entries: 1024 (order: -1, 4096 bytes)
Dentry cache hash table entries: 32768 (order: 4, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 3, 65536 bytes)
Memory Available: 248M / 256M (1312K code, 463K data, 4184K init, 1400K
reserv)
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:16
Console: colour dummy device 80x25
Calibrating delay loop... 39.73 BogoMIPS (lpj=198656)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 1024
devtmpfs: initialized
[plat-arcfpga]: registering device resources
bio: create slab <bio-0> at 0
Switching to clocksource ARC RTSC
io scheduler noop registered (default)
arc-uart: ttyARC0 at MMIO 0xc0fc1000 (irq = 5) is a arc-uart
console [ttyARC0] enabled, bootconsole disabled
console [ttyARC0] enabled, bootconsole disabled
mousedev: PS/2 mouse device common for all mice
Warning: unable to open an initial console.
Freeing unused kernel memory: 4184k [80002000] to [80418000]
Mounting proc
Mounting sysfs
Mounting devpts
Setting hostname to ARCLinux
Starting System logger (syslogd)
Bringing up loopback device
ifconfig: socket: Function not implemented
route: socket: Function not implemented
Disk not detected !
Mounting tmpfs
mount: mounting tmpfs on /dev/shm failed: Invalid argument
/etc/init.d/rcS: line 76: can't create /proc/sys/kernel/msgmni:
nonexistent directory

Please press Enter to activate this console.
***********************************************************************
                        Welcome to ARCLinux
***********************************************************************
[ARCLinux]$

---------------------------------->8-----------------------------------

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/configs/fpga_defconfig |   46 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/configs/fpga_defconfig

diff --git a/arch/arc/configs/fpga_defconfig b/arch/arc/configs/fpga_defconfig
new file mode 100644
index 0000000..8638e101f
--- /dev/null
+++ b/arch/arc/configs/fpga_defconfig
@@ -0,0 +1,46 @@
+CONFIG_CROSS_COMPILE="arc-elf32-"
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
+CONFIG_INITRAMFS_SOURCE="../arc_initramfs"
+CONFIG_EXPERT=y
+# CONFIG_FUTEX is not set
+# CONFIG_COMPAT_BRK is not set
+# CONFIG_LBDAF is not set
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+# CONFIG_IOSCHED_CFQ is not set
+CONFIG_ARC_BUILTIN_DTB_NAME="angel4"
+# CONFIG_COMPACTION is not set
+# CONFIG_CROSS_MEMORY_ATTACH is not set
+# CONFIG_STANDALONE is not set
+# CONFIG_PREVENT_FIRMWARE_BUILD is not set
+# CONFIG_FIRMWARE_IN_KERNEL is not set
+# CONFIG_BLK_DEV is not set
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
+# CONFIG_DNOTIFY is not set
+# CONFIG_INOTIFY_USER is not set
+# CONFIG_MISC_FILESYSTEMS is not set
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
+# CONFIG_ENABLE_MUST_CHECK is not set
+CONFIG_XZ_DEC=y
-- 
1.7.4.1

