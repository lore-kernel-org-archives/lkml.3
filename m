Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762752Ab3JQU3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:29:08 -0400
Received: from dukecmmtar03.coxmail.com ([68.99.120.44]:43464 "EHLO
	dukecmmtar03.coxmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762730Ab3JQU3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:29:07 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: linux-usb@vger.kernel.org
Subject: [PATCH 1/2 v4] ARM: ep93xx_defconfig: cleanup ep93xx_defconfig
Date: Thu, 17 Oct 2013 13:27:40 -0700
User-Agent: KMail/1.9.9
Cc: ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>, stern@rowland.harvard.edu,
        Lennert Buytenhek <buytenh@wantstofly.org>, gregkh@linuxfoundation.org,
        olof@lixom.net, Russell King <linux@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201310171327.40863.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generate ep93xx_defconfig by doing:

make ep93xx_defconfig
make savedefconfig
mv defconfig arch/arm/configs/ep93xx_defconfig

No function change. This just refreshes the ep93xx_defconfig to make it
easier and cleaner when adding new entries.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Ryan Mallon <rmallon@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/configs/ep93xx_defconfig | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/arm/configs/ep93xx_defconfig b/arch/arm/configs/ep93xx_defconfig
index 806005a..8eccbcb 100644
--- a/arch/arm/configs/ep93xx_defconfig
+++ b/arch/arm/configs/ep93xx_defconfig
@@ -1,15 +1,14 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
+CONFIG_PARTITION_ADVANCED=y
 # CONFIG_IOSCHED_CFQ is not set
 CONFIG_ARCH_EP93XX=y
 CONFIG_CRUNCH=y
@@ -47,11 +46,8 @@ CONFIG_IPV6=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_ADV_OPTIONS=y
@@ -67,15 +63,14 @@ CONFIG_SCSI=y
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
 CONFIG_NETDEVICES=y
-CONFIG_NET_ETHERNET=y
 CONFIG_EP93XX_ETH=y
 CONFIG_USB_RTL8150=y
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
+# CONFIG_LEGACY_PTYS is not set
 CONFIG_SERIAL_AMBA_PL010=y
 CONFIG_SERIAL_AMBA_PL010_CONSOLE=y
-# CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
@@ -86,7 +81,6 @@ CONFIG_WATCHDOG=y
 CONFIG_EP93XX_WATCHDOG=y
 CONFIG_USB=y
 CONFIG_USB_DEBUG=y
-CONFIG_USB_DEVICEFS=y
 CONFIG_USB_DYNAMIC_MINORS=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_STORAGE=y
@@ -100,24 +94,18 @@ CONFIG_RTC_DRV_EP93XX=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_FS_XATTR is not set
-CONFIG_INOTIFY=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
 CONFIG_JFFS2_FS=y
 CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
 CONFIG_ROOT_NFS=y
-CONFIG_PARTITION_ADVANCED=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_MAGIC_SYSRQ=y
-CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_SLAB=y
 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_MUTEXES=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_DEBUG_USER=y
-CONFIG_DEBUG_ERRORS=y
 CONFIG_DEBUG_LL=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_LIBCRC32C=y
-- 
1.8.3.2

