Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3GADPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 23:15:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43469 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612Ab3GADO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 23:14:56 -0400
X-Sasl-enc: 9fCphU1pGmxD2aS8agwHP0tkQBwuVYUMxxvlpgkrdN7a 1372648494
Subject: [RFC PATCH 7/7] autofs - change CONFIG_AUTOFS4_FS to
 CONFIG_AUTOFS_FS
To: linux-next@vger.kernel.org
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 01 Jul 2013 11:14:51 +0800
Message-ID: <20130701031449.4423.58614.stgit@perseus.fritz.box>
In-Reply-To: <20130701031335.4423.6154.stgit@perseus.fritz.box>
References: <20130701031335.4423.6154.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Kent <raven@themaw.net>
---
 arch/arm/configs/at91rm9200_defconfig        |    2 +-
 arch/arm/configs/bcm_defconfig               |    2 +-
 arch/arm/configs/cns3420vb_defconfig         |    2 +-
 arch/arm/configs/colibri_pxa270_defconfig    |    2 +-
 arch/arm/configs/da8xx_omapl_defconfig       |    2 +-
 arch/arm/configs/davinci_all_defconfig       |    2 +-
 arch/arm/configs/ebsa110_defconfig           |    2 +-
 arch/arm/configs/ezx_defconfig               |    2 +-
 arch/arm/configs/footbridge_defconfig        |    2 +-
 arch/arm/configs/imote2_defconfig            |    2 +-
 arch/arm/configs/imx_v6_v7_defconfig         |    2 +-
 arch/arm/configs/lpc32xx_defconfig           |    2 +-
 arch/arm/configs/mini2440_defconfig          |    2 +-
 arch/arm/configs/omap1_defconfig             |    2 +-
 arch/arm/configs/rpc_defconfig               |    2 +-
 arch/arm/configs/s3c2410_defconfig           |    2 +-
 arch/arm/configs/spear13xx_defconfig         |    2 +-
 arch/arm/configs/spear3xx_defconfig          |    2 +-
 arch/arm/configs/spear6xx_defconfig          |    2 +-
 arch/arm/configs/trizeps4_defconfig          |    2 +-
 arch/ia64/configs/bigsur_defconfig           |    2 +-
 arch/ia64/configs/generic_defconfig          |    2 +-
 arch/ia64/configs/gensparse_defconfig        |    2 +-
 arch/ia64/configs/tiger_defconfig            |    2 +-
 arch/ia64/configs/xen_domu_defconfig         |    2 +-
 arch/m68k/configs/amiga_defconfig            |    2 +-
 arch/m68k/configs/apollo_defconfig           |    2 +-
 arch/m68k/configs/atari_defconfig            |    2 +-
 arch/m68k/configs/bvme6000_defconfig         |    2 +-
 arch/m68k/configs/hp300_defconfig            |    2 +-
 arch/m68k/configs/mac_defconfig              |    2 +-
 arch/m68k/configs/multi_defconfig            |    2 +-
 arch/m68k/configs/mvme147_defconfig          |    2 +-
 arch/m68k/configs/mvme16x_defconfig          |    2 +-
 arch/m68k/configs/q40_defconfig              |    2 +-
 arch/m68k/configs/sun3_defconfig             |    2 +-
 arch/m68k/configs/sun3x_defconfig            |    2 +-
 arch/mips/configs/bcm47xx_defconfig          |    2 +-
 arch/mips/configs/bigsur_defconfig           |    2 +-
 arch/mips/configs/capcella_defconfig         |    2 +-
 arch/mips/configs/e55_defconfig              |    2 +-
 arch/mips/configs/fuloong2e_defconfig        |    2 +-
 arch/mips/configs/ip22_defconfig             |    2 +-
 arch/mips/configs/ip32_defconfig             |    2 +-
 arch/mips/configs/jazz_defconfig             |    2 +-
 arch/mips/configs/lemote2f_defconfig         |    2 +-
 arch/mips/configs/markeins_defconfig         |    2 +-
 arch/mips/configs/mpc30x_defconfig           |    2 +-
 arch/mips/configs/mtx1_defconfig             |    2 +-
 arch/mips/configs/nlm_xlp_defconfig          |    2 +-
 arch/mips/configs/nlm_xlr_defconfig          |    2 +-
 arch/mips/configs/rm200_defconfig            |    2 +-
 arch/mips/configs/tb0219_defconfig           |    2 +-
 arch/mips/configs/tb0226_defconfig           |    2 +-
 arch/mips/configs/tb0287_defconfig           |    2 +-
 arch/mips/configs/workpad_defconfig          |    2 +-
 arch/parisc/configs/712_defconfig            |    2 +-
 arch/parisc/configs/a500_defconfig           |    2 +-
 arch/parisc/configs/b180_defconfig           |    2 +-
 arch/parisc/configs/c3000_defconfig          |    2 +-
 arch/powerpc/configs/40x/virtex_defconfig    |    2 +-
 arch/powerpc/configs/44x/sam440ep_defconfig  |    2 +-
 arch/powerpc/configs/44x/virtex5_defconfig   |    2 +-
 arch/powerpc/configs/85xx/stx_gp3_defconfig  |    2 +-
 arch/powerpc/configs/86xx/sbc8641d_defconfig |    2 +-
 arch/powerpc/configs/c2k_defconfig           |    2 +-
 arch/powerpc/configs/cell_defconfig          |    2 +-
 arch/powerpc/configs/ep8248e_defconfig       |    2 +-
 arch/powerpc/configs/mgcoge_defconfig        |    2 +-
 arch/powerpc/configs/mpc8272_ads_defconfig   |    2 +-
 arch/powerpc/configs/pasemi_defconfig        |    2 +-
 arch/powerpc/configs/pmac32_defconfig        |    2 +-
 arch/powerpc/configs/ppc64_defconfig         |    2 +-
 arch/powerpc/configs/ppc64e_defconfig        |    2 +-
 arch/powerpc/configs/ppc6xx_defconfig        |    2 +-
 arch/powerpc/configs/pq2fads_defconfig       |    2 +-
 arch/powerpc/configs/ps3_defconfig           |    2 +-
 arch/powerpc/configs/pseries_defconfig       |    2 +-
 arch/score/configs/spct6600_defconfig        |    2 +-
 arch/sh/configs/espt_defconfig               |    2 +-
 arch/sh/configs/sdk7780_defconfig            |    2 +-
 arch/sh/configs/sdk7786_defconfig            |    2 +-
 arch/sh/configs/sh03_defconfig               |    2 +-
 arch/sh/configs/sh7763rdp_defconfig          |    2 +-
 arch/sparc/configs/sparc32_defconfig         |    2 +-
 arch/tile/configs/tilegx_defconfig           |    2 +-
 arch/tile/configs/tilepro_defconfig          |    2 +-
 arch/um/defconfig                            |    2 +-
 arch/x86/configs/i386_defconfig              |    2 +-
 arch/x86/configs/x86_64_defconfig            |    2 +-
 arch/xtensa/configs/common_defconfig         |    1 -
 arch/xtensa/configs/iss_defconfig            |    1 -
 arch/xtensa/configs/s6105_defconfig          |    1 -
 93 files changed, 90 insertions(+), 93 deletions(-)

diff --git a/arch/arm/configs/at91rm9200_defconfig b/arch/arm/configs/at91rm9200_defconfig
index 75502c4..db89c6e 100644
--- a/arch/arm/configs/at91rm9200_defconfig
+++ b/arch/arm/configs/at91rm9200_defconfig
@@ -139,7 +139,7 @@ CONFIG_LEDS_TRIGGER_GPIO=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_AT91RM9200=y
 CONFIG_EXT4_FS=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
 CONFIG_UBIFS_FS=y
diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index e3bf2d6..b9ace84 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -87,7 +87,7 @@ CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
 CONFIG_EXT4_FS=y
 CONFIG_EXT4_FS_POSIX_ACL=y
 CONFIG_EXT4_FS_SECURITY=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_FUSE_FS=y
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
diff --git a/arch/arm/configs/cns3420vb_defconfig b/arch/arm/configs/cns3420vb_defconfig
index b1ff5cd..b3c203e 100644
--- a/arch/arm/configs/cns3420vb_defconfig
+++ b/arch/arm/configs/cns3420vb_defconfig
@@ -64,7 +64,7 @@ CONFIG_MMC_SDHCI_PLTFM=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
 CONFIG_INOTIFY=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_FSCACHE=y
 CONFIG_TMPFS=y
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
diff --git a/arch/arm/configs/colibri_pxa270_defconfig b/arch/arm/configs/colibri_pxa270_defconfig
index 2ef2c5e..5303c56 100644
--- a/arch/arm/configs/colibri_pxa270_defconfig
+++ b/arch/arm/configs/colibri_pxa270_defconfig
@@ -135,7 +135,7 @@ CONFIG_RTC_CLASS=y
 # CONFIG_RTC_HCTOSYS is not set
 CONFIG_RTC_DRV_PCF8583=m
 CONFIG_INOTIFY=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_MSDOS_FS=m
 CONFIG_VFAT_FS=m
 CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
diff --git a/arch/arm/configs/da8xx_omapl_defconfig b/arch/arm/configs/da8xx_omapl_defconfig
index 7c86813..d6cf64b 100644
--- a/arch/arm/configs/da8xx_omapl_defconfig
+++ b/arch/arm/configs/da8xx_omapl_defconfig
@@ -106,7 +106,7 @@ CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_XFS_FS=m
 CONFIG_INOTIFY=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
diff --git a/arch/arm/configs/davinci_all_defconfig b/arch/arm/configs/davinci_all_defconfig
index c86fd75..a683475 100644
--- a/arch/arm/configs/davinci_all_defconfig
+++ b/arch/arm/configs/davinci_all_defconfig
@@ -166,7 +166,7 @@ CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_XFS_FS=m
 CONFIG_INOTIFY=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
diff --git a/arch/arm/configs/ebsa110_defconfig b/arch/arm/configs/ebsa110_defconfig
index 14559db..ed8327f 100644
--- a/arch/arm/configs/ebsa110_defconfig
+++ b/arch/arm/configs/ebsa110_defconfig
@@ -66,7 +66,7 @@ CONFIG_SERIAL_8250_CS=m
 CONFIG_PRINTER=m
 CONFIG_WATCHDOG=y
 CONFIG_SOFT_WATCHDOG=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_MINIX_FS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
diff --git a/arch/arm/configs/ezx_defconfig b/arch/arm/configs/ezx_defconfig
index d95763d..50f3b4d 100644
--- a/arch/arm/configs/ezx_defconfig
+++ b/arch/arm/configs/ezx_defconfig
@@ -315,7 +315,7 @@ CONFIG_REISERFS_FS_SECURITY=y
 CONFIG_XFS_FS=m
 CONFIG_INOTIFY=y
 CONFIG_AUTOFS_FS=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_FUSE_FS=m
 CONFIG_CUSE=m
 CONFIG_ISO9660_FS=m
diff --git a/arch/arm/configs/footbridge_defconfig b/arch/arm/configs/footbridge_defconfig
index 038518a..5f2a428 100644
--- a/arch/arm/configs/footbridge_defconfig
+++ b/arch/arm/configs/footbridge_defconfig
@@ -105,7 +105,7 @@ CONFIG_USB_DEVICEFS=y
 CONFIG_USB_MON=m
 CONFIG_USB_PRINTER=m
 CONFIG_EXT2_FS=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
 CONFIG_MSDOS_FS=m
diff --git a/arch/arm/configs/imote2_defconfig b/arch/arm/configs/imote2_defconfig
index fd996bb..c613896 100644
--- a/arch/arm/configs/imote2_defconfig
+++ b/arch/arm/configs/imote2_defconfig
@@ -286,7 +286,7 @@ CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=m
 CONFIG_INOTIFY=y
 CONFIG_AUTOFS_FS=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_FUSE_FS=m
 CONFIG_CUSE=m
 CONFIG_MSDOS_FS=m
diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index 2353bde..68c2ffe 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -238,7 +238,7 @@ CONFIG_EXT4_FS_SECURITY=y
 CONFIG_QUOTA=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_FUSE_FS=y
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
diff --git a/arch/arm/configs/lpc32xx_defconfig b/arch/arm/configs/lpc32xx_defconfig
index 398a367..8f9d3eb 100644
--- a/arch/arm/configs/lpc32xx_defconfig
+++ b/arch/arm/configs/lpc32xx_defconfig
@@ -183,7 +183,7 @@ CONFIG_MAX517=y
 CONFIG_PWM=y
 CONFIG_PWM_LPC32XX=y
 CONFIG_EXT2_FS=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
diff --git a/arch/arm/configs/mini2440_defconfig b/arch/arm/configs/mini2440_defconfig
index a07948a..ce6c835 100644
--- a/arch/arm/configs/mini2440_defconfig
+++ b/arch/arm/configs/mini2440_defconfig
@@ -268,7 +268,7 @@ CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT3_FS_SECURITY=y
 CONFIG_INOTIFY=y
 CONFIG_AUTOFS_FS=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
index d74edba..8fae376 100644
--- a/arch/arm/configs/omap1_defconfig
+++ b/arch/arm/configs/omap1_defconfig
@@ -231,7 +231,7 @@ CONFIG_RTC_DRV_OMAP=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_DNOTIFY is not set
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
 CONFIG_MSDOS_FS=y
diff --git a/arch/arm/configs/rpc_defconfig b/arch/arm/configs/rpc_defconfig
index 00515ef..f2ebb47 100644
--- a/arch/arm/configs/rpc_defconfig
+++ b/arch/arm/configs/rpc_defconfig
@@ -88,7 +88,7 @@ CONFIG_RTC_DRV_PCF8583=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_INOTIFY=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
 CONFIG_MSDOS_FS=m
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_defconfig
index 193448f..b3f829f 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -396,7 +396,7 @@ CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT4_FS=m
 CONFIG_EXT4_FS_POSIX_ACL=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
diff --git a/arch/arm/configs/spear13xx_defconfig b/arch/arm/configs/spear13xx_defconfig
index 1fdb826..5a803b3 100644
--- a/arch/arm/configs/spear13xx_defconfig
+++ b/arch/arm/configs/spear13xx_defconfig
@@ -79,7 +79,7 @@ CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT2_FS_SECURITY=y
 CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_SECURITY=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_MSDOS_FS=m
 CONFIG_VFAT_FS=m
 CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
diff --git a/arch/arm/configs/spear3xx_defconfig b/arch/arm/configs/spear3xx_defconfig
index 7ff23a0..70e4d8d 100644
--- a/arch/arm/configs/spear3xx_defconfig
+++ b/arch/arm/configs/spear3xx_defconfig
@@ -73,7 +73,7 @@ CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT2_FS_SECURITY=y
 CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_SECURITY=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_MSDOS_FS=m
 CONFIG_VFAT_FS=m
 CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
diff --git a/arch/arm/configs/spear6xx_defconfig b/arch/arm/configs/spear6xx_defconfig
index 7822980..c1fadf0 100644
--- a/arch/arm/configs/spear6xx_defconfig
+++ b/arch/arm/configs/spear6xx_defconfig
@@ -62,7 +62,7 @@ CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT2_FS_SECURITY=y
 CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_SECURITY=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_MSDOS_FS=m
 CONFIG_VFAT_FS=m
 CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
diff --git a/arch/arm/configs/trizeps4_defconfig b/arch/arm/configs/trizeps4_defconfig
index 3162173..677f482 100644
--- a/arch/arm/configs/trizeps4_defconfig
+++ b/arch/arm/configs/trizeps4_defconfig
@@ -187,7 +187,7 @@ CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT3_FS_SECURITY=y
 CONFIG_INOTIFY=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_MSDOS_FS=m
 CONFIG_VFAT_FS=m
 CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
diff --git a/arch/ia64/configs/bigsur_defconfig b/arch/ia64/configs/bigsur_defconfig
index cf5993f..dab25bc 100644
--- a/arch/ia64/configs/bigsur_defconfig
+++ b/arch/ia64/configs/bigsur_defconfig
@@ -87,7 +87,7 @@ CONFIG_XFS_FS=y
 CONFIG_XFS_QUOTA=y
 CONFIG_XFS_POSIX_ACL=y
 CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=m
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
 CONFIG_UDF_FS=m
diff --git a/arch/ia64/configs/generic_defconfig b/arch/ia64/configs/generic_defconfig
index 7913695..792a32e 100644
--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@ -167,7 +167,7 @@ CONFIG_REISERFS_FS_POSIX_ACL=y
 CONFIG_REISERFS_FS_SECURITY=y
 CONFIG_XFS_FS=y
 CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=m
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
 CONFIG_UDF_FS=m
diff --git a/arch/ia64/configs/gensparse_defconfig b/arch/ia64/configs/gensparse_defconfig
index f8e9133..15447e3 100644
--- a/arch/ia64/configs/gensparse_defconfig
+++ b/arch/ia64/configs/gensparse_defconfig
@@ -148,7 +148,7 @@ CONFIG_REISERFS_FS_POSIX_ACL=y
 CONFIG_REISERFS_FS_SECURITY=y
 CONFIG_XFS_FS=y
 CONFIG_AUTOFS_FS=y
-CONFIG_AUTOFS4_FS=y
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
 CONFIG_UDF_FS=m
diff --git a/arch/ia64/configs/tiger_defconfig b/arch/ia64/configs/tiger_defconfig
index a5a9e02..af2e3d2 100644
--- a/arch/ia64/configs/tiger_defconfig
+++ b/arch/ia64/configs/tiger_defconfig
@@ -121,7 +121,7 @@ CONFIG_REISERFS_FS_POSIX_ACL=y
 CONFIG_REISERFS_FS_SECURITY=y
 CONFIG_XFS_FS=y
 CONFIG_AUTOFS_FS=y
-CONFIG_AUTOFS4_FS=y
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
 CONFIG_UDF_FS=m
diff --git a/arch/ia64/configs/xen_domu_defconfig b/arch/ia64/configs/xen_domu_defconfig
index 37b9b42..cdcaac1 100644
--- a/arch/ia64/configs/xen_domu_defconfig
+++ b/arch/ia64/configs/xen_domu_defconfig
@@ -131,7 +131,7 @@ CONFIG_REISERFS_FS_POSIX_ACL=y
 CONFIG_REISERFS_FS_SECURITY=y
 CONFIG_XFS_FS=y
 CONFIG_AUTOFS_FS=y
-CONFIG_AUTOFS4_FS=y
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
 CONFIG_UDF_FS=m
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index 19325e1..449fe05 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -358,7 +358,7 @@ CONFIG_OCFS2_FS=m
 CONFIG_FANOTIFY=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_CUSE=m
 CONFIG_ISO9660_FS=y
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 14dc6cc..de90302 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -315,7 +315,7 @@ CONFIG_OCFS2_FS=m
 CONFIG_FANOTIFY=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_CUSE=m
 CONFIG_ISO9660_FS=y
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index 6d5370c..8f4c568 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -333,7 +333,7 @@ CONFIG_OCFS2_FS=m
 CONFIG_FANOTIFY=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_CUSE=m
 CONFIG_ISO9660_FS=y
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index c015ddb..09b9802 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -307,7 +307,7 @@ CONFIG_OCFS2_FS=m
 CONFIG_FANOTIFY=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_CUSE=m
 CONFIG_ISO9660_FS=y
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index ec7382d..46a500a 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -317,7 +317,7 @@ CONFIG_OCFS2_FS=m
 CONFIG_FANOTIFY=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_CUSE=m
 CONFIG_ISO9660_FS=y
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index 7d46fbe..b1d3abe 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -340,7 +340,7 @@ CONFIG_OCFS2_FS=m
 CONFIG_FANOTIFY=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_CUSE=m
 CONFIG_ISO9660_FS=y
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index b17a883..7c27aa2 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -418,7 +418,7 @@ CONFIG_OCFS2_FS=m
 CONFIG_FANOTIFY=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_CUSE=m
 CONFIG_ISO9660_FS=y
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index 5586c65..281cdd8 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -307,7 +307,7 @@ CONFIG_OCFS2_FS=m
 CONFIG_FANOTIFY=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_CUSE=m
 CONFIG_ISO9660_FS=y
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index e5e8262..8af7a4d 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -307,7 +307,7 @@ CONFIG_OCFS2_FS=m
 CONFIG_FANOTIFY=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_CUSE=m
 CONFIG_ISO9660_FS=y
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index be1496e..e9ada99 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -331,7 +331,7 @@ CONFIG_OCFS2_FS=m
 CONFIG_FANOTIFY=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_CUSE=m
 CONFIG_ISO9660_FS=y
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 54674d6..cc1eeee 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -309,7 +309,7 @@ CONFIG_OCFS2_FS=m
 CONFIG_FANOTIFY=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_CUSE=m
 CONFIG_ISO9660_FS=y
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index 832d953..7436323 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -309,7 +309,7 @@ CONFIG_OCFS2_FS=m
 CONFIG_FANOTIFY=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_CUSE=m
 CONFIG_ISO9660_FS=y
diff --git a/arch/mips/configs/bcm47xx_defconfig b/arch/mips/configs/bcm47xx_defconfig
index 4ca8e5c..a2ae007 100644
--- a/arch/mips/configs/bcm47xx_defconfig
+++ b/arch/mips/configs/bcm47xx_defconfig
@@ -506,7 +506,7 @@ CONFIG_QUOTA_NETLINK_INTERFACE=y
 CONFIG_QFMT_V1=m
 CONFIG_QFMT_V2=m
 CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=m
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_FUSE_FS=m
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index 1cdff6b..d33c492 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -184,7 +184,7 @@ CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
 CONFIG_QFMT_V2=m
 CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=m
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_FUSE_FS=m
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
diff --git a/arch/mips/configs/capcella_defconfig b/arch/mips/configs/capcella_defconfig
index 5135dc0..aa01aa0 100644
--- a/arch/mips/configs/capcella_defconfig
+++ b/arch/mips/configs/capcella_defconfig
@@ -65,7 +65,7 @@ CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_VR41XX=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
diff --git a/arch/mips/configs/e55_defconfig b/arch/mips/configs/e55_defconfig
index 0126e66..eda3e7d 100644
--- a/arch/mips/configs/e55_defconfig
+++ b/arch/mips/configs/e55_defconfig
@@ -34,7 +34,7 @@ CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_VR41XX=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
diff --git a/arch/mips/configs/fuloong2e_defconfig b/arch/mips/configs/fuloong2e_defconfig
index e5b73de..765f029 100644
--- a/arch/mips/configs/fuloong2e_defconfig
+++ b/arch/mips/configs/fuloong2e_defconfig
@@ -221,7 +221,7 @@ CONFIG_EXT4_FS_POSIX_ACL=y
 CONFIG_EXT4_FS_SECURITY=y
 CONFIG_REISERFS_FS=m
 CONFIG_AUTOFS_FS=y
-CONFIG_AUTOFS4_FS=y
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_FUSE_FS=y
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
diff --git a/arch/mips/configs/ip22_defconfig b/arch/mips/configs/ip22_defconfig
index 936ec5a..b06185e7 100644
--- a/arch/mips/configs/ip22_defconfig
+++ b/arch/mips/configs/ip22_defconfig
@@ -289,7 +289,7 @@ CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
 CONFIG_QFMT_V2=m
 CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=m
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_FUSE_FS=m
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index 7bbd521..9657282 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -118,7 +118,7 @@ CONFIG_QUOTA=y
 CONFIG_QFMT_V1=m
 CONFIG_QFMT_V2=m
 CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=m
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_FUSE_FS=m
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
diff --git a/arch/mips/configs/jazz_defconfig b/arch/mips/configs/jazz_defconfig
index 0315ee3..20fb38ec 100644
--- a/arch/mips/configs/jazz_defconfig
+++ b/arch/mips/configs/jazz_defconfig
@@ -278,7 +278,7 @@ CONFIG_REISERFS_FS_SECURITY=y
 CONFIG_XFS_FS=m
 CONFIG_XFS_QUOTA=y
 CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=m
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_FUSE_FS=m
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
index 343bebc..474d515 100644
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -350,7 +350,7 @@ CONFIG_BTRFS_FS=m
 CONFIG_QUOTA=y
 CONFIG_QFMT_V2=m
 CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=m
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_FSCACHE=m
 CONFIG_CACHEFILES=m
 CONFIG_ISO9660_FS=m
diff --git a/arch/mips/configs/markeins_defconfig b/arch/mips/configs/markeins_defconfig
index 636f82b..54104cf 100644
--- a/arch/mips/configs/markeins_defconfig
+++ b/arch/mips/configs/markeins_defconfig
@@ -177,7 +177,7 @@ CONFIG_EXT2_FS_SECURITY=y
 CONFIG_EXT3_FS=m
 CONFIG_XFS_FS=m
 # CONFIG_DNOTIFY is not set
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_NTFS_FS=m
diff --git a/arch/mips/configs/mpc30x_defconfig b/arch/mips/configs/mpc30x_defconfig
index c16de98..64d05cd 100644
--- a/arch/mips/configs/mpc30x_defconfig
+++ b/arch/mips/configs/mpc30x_defconfig
@@ -53,7 +53,7 @@ CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_VR41XX=y
 CONFIG_EXT2_FS=y
 CONFIG_AUTOFS_FS=y
-CONFIG_AUTOFS4_FS=y
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_PROC_KCORE=y
 CONFIG_CONFIGFS_FS=m
 CONFIG_NFS_FS=y
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index 9fa8f16..fa9a790 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -698,7 +698,7 @@ CONFIG_EXT3_FS=m
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT3_FS_SECURITY=y
 CONFIG_QUOTA=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_FUSE_FS=m
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
diff --git a/arch/mips/configs/nlm_xlp_defconfig b/arch/mips/configs/nlm_xlp_defconfig
index 5468b1c..a2fb24c 100644
--- a/arch/mips/configs/nlm_xlp_defconfig
+++ b/arch/mips/configs/nlm_xlp_defconfig
@@ -457,7 +457,7 @@ CONFIG_BTRFS_FS=m
 CONFIG_BTRFS_FS_POSIX_ACL=y
 CONFIG_NILFS2_FS=m
 CONFIG_QUOTA_NETLINK_INTERFACE=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=y
 CONFIG_CUSE=m
 CONFIG_FSCACHE=m
diff --git a/arch/mips/configs/nlm_xlr_defconfig b/arch/mips/configs/nlm_xlr_defconfig
index 44b4734..20f1243 100644
--- a/arch/mips/configs/nlm_xlr_defconfig
+++ b/arch/mips/configs/nlm_xlr_defconfig
@@ -397,7 +397,7 @@ CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
 CONFIG_QFMT_V1=m
 CONFIG_QFMT_V2=m
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=y
 CONFIG_CUSE=m
 CONFIG_FSCACHE=m
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index 59d9d2f..0bd541e 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -369,7 +369,7 @@ CONFIG_REISERFS_FS_SECURITY=y
 CONFIG_XFS_FS=m
 CONFIG_XFS_QUOTA=y
 CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=m
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_FUSE_FS=m
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
diff --git a/arch/mips/configs/tb0219_defconfig b/arch/mips/configs/tb0219_defconfig
index 30036b4..8bb94e0 100644
--- a/arch/mips/configs/tb0219_defconfig
+++ b/arch/mips/configs/tb0219_defconfig
@@ -81,7 +81,7 @@ CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_VR41XX=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
diff --git a/arch/mips/configs/tb0226_defconfig b/arch/mips/configs/tb0226_defconfig
index 81bfa1d..9743b31 100644
--- a/arch/mips/configs/tb0226_defconfig
+++ b/arch/mips/configs/tb0226_defconfig
@@ -78,7 +78,7 @@ CONFIG_USB_STORAGE=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_VR41XX=y
 CONFIG_EXT2_FS=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
diff --git a/arch/mips/configs/tb0287_defconfig b/arch/mips/configs/tb0287_defconfig
index c415c4f..e15ea36 100644
--- a/arch/mips/configs/tb0287_defconfig
+++ b/arch/mips/configs/tb0287_defconfig
@@ -96,7 +96,7 @@ CONFIG_EXT3_FS=y
 CONFIG_XFS_FS=y
 CONFIG_XFS_QUOTA=y
 CONFIG_XFS_POSIX_ACL=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
diff --git a/arch/mips/configs/workpad_defconfig b/arch/mips/configs/workpad_defconfig
index ee4b2be..33a6683 100644
--- a/arch/mips/configs/workpad_defconfig
+++ b/arch/mips/configs/workpad_defconfig
@@ -61,7 +61,7 @@ CONFIG_RTC_DRV_VR41XX=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT3_FS=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
diff --git a/arch/parisc/configs/712_defconfig b/arch/parisc/configs/712_defconfig
index 0f90569..a3879f8 100644
--- a/arch/parisc/configs/712_defconfig
+++ b/arch/parisc/configs/712_defconfig
@@ -118,7 +118,7 @@ CONFIG_EXT3_FS=y
 # CONFIG_EXT3_FS_XATTR is not set
 CONFIG_JFS_FS=m
 CONFIG_XFS_FS=m
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
 CONFIG_UDF_FS=m
diff --git a/arch/parisc/configs/a500_defconfig b/arch/parisc/configs/a500_defconfig
index b647b18..cf85bc1 100644
--- a/arch/parisc/configs/a500_defconfig
+++ b/arch/parisc/configs/a500_defconfig
@@ -160,7 +160,7 @@ CONFIG_EXT3_FS=y
 # CONFIG_EXT3_FS_XATTR is not set
 CONFIG_JFS_FS=m
 CONFIG_XFS_FS=m
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
 CONFIG_UDF_FS=m
diff --git a/arch/parisc/configs/b180_defconfig b/arch/parisc/configs/b180_defconfig
index e289f5b..3e92363 100644
--- a/arch/parisc/configs/b180_defconfig
+++ b/arch/parisc/configs/b180_defconfig
@@ -82,7 +82,7 @@ CONFIG_SND_HARMONY=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_FS_XATTR is not set
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
 CONFIG_PROC_KCORE=y
diff --git a/arch/parisc/configs/c3000_defconfig b/arch/parisc/configs/c3000_defconfig
index 311ca36..047ef19 100644
--- a/arch/parisc/configs/c3000_defconfig
+++ b/arch/parisc/configs/c3000_defconfig
@@ -140,7 +140,7 @@ CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_FS_XATTR is not set
 CONFIG_XFS_FS=m
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
 CONFIG_MSDOS_FS=m
diff --git a/arch/powerpc/configs/40x/virtex_defconfig b/arch/powerpc/configs/40x/virtex_defconfig
index 0a81e1f..2aa127b 100644
--- a/arch/powerpc/configs/40x/virtex_defconfig
+++ b/arch/powerpc/configs/40x/virtex_defconfig
@@ -69,7 +69,7 @@ CONFIG_LOGO=y
 CONFIG_EXT2_FS=y
 CONFIG_INOTIFY=y
 CONFIG_AUTOFS_FS=y
-CONFIG_AUTOFS4_FS=y
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
diff --git a/arch/powerpc/configs/44x/sam440ep_defconfig b/arch/powerpc/configs/44x/sam440ep_defconfig
index ca088cd..ed98042 100644
--- a/arch/powerpc/configs/44x/sam440ep_defconfig
+++ b/arch/powerpc/configs/44x/sam440ep_defconfig
@@ -101,7 +101,7 @@ CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_REISERFS_FS=y
 CONFIG_INOTIFY=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
 CONFIG_ZISOFS=y
diff --git a/arch/powerpc/configs/44x/virtex5_defconfig b/arch/powerpc/configs/44x/virtex5_defconfig
index 1eb3caf..11a6c1e 100644
--- a/arch/powerpc/configs/44x/virtex5_defconfig
+++ b/arch/powerpc/configs/44x/virtex5_defconfig
@@ -68,7 +68,7 @@ CONFIG_LOGO=y
 CONFIG_EXT2_FS=y
 CONFIG_INOTIFY=y
 CONFIG_AUTOFS_FS=y
-CONFIG_AUTOFS4_FS=y
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
diff --git a/arch/powerpc/configs/85xx/stx_gp3_defconfig b/arch/powerpc/configs/85xx/stx_gp3_defconfig
index 5d4db15..01f7a77 100644
--- a/arch/powerpc/configs/85xx/stx_gp3_defconfig
+++ b/arch/powerpc/configs/85xx/stx_gp3_defconfig
@@ -65,7 +65,7 @@ CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 CONFIG_INOTIFY=y
 CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=y
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_ISO9660_FS=m
 CONFIG_UDF_FS=m
 CONFIG_MSDOS_FS=m
diff --git a/arch/powerpc/configs/86xx/sbc8641d_defconfig b/arch/powerpc/configs/86xx/sbc8641d_defconfig
index 1a62baf..bf44180 100644
--- a/arch/powerpc/configs/86xx/sbc8641d_defconfig
+++ b/arch/powerpc/configs/86xx/sbc8641d_defconfig
@@ -195,7 +195,7 @@ CONFIG_REISERFS_FS_POSIX_ACL=y
 CONFIG_OCFS2_FS=m
 CONFIG_INOTIFY=y
 CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=m
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_MINIX_FS=m
diff --git a/arch/powerpc/configs/c2k_defconfig b/arch/powerpc/configs/c2k_defconfig
index 671a8f9..edebe72 100644
--- a/arch/powerpc/configs/c2k_defconfig
+++ b/arch/powerpc/configs/c2k_defconfig
@@ -339,7 +339,7 @@ CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT3_FS_SECURITY=y
 CONFIG_QUOTA=y
 CONFIG_QFMT_V2=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_UDF_FS=m
 CONFIG_MSDOS_FS=m
 CONFIG_VFAT_FS=m
diff --git a/arch/powerpc/configs/cell_defconfig b/arch/powerpc/configs/cell_defconfig
index 22a403d..d98375c 100644
--- a/arch/powerpc/configs/cell_defconfig
+++ b/arch/powerpc/configs/cell_defconfig
@@ -199,7 +199,7 @@ CONFIG_UIO=m
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_INOTIFY=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
 CONFIG_UDF_FS=m
diff --git a/arch/powerpc/configs/ep8248e_defconfig b/arch/powerpc/configs/ep8248e_defconfig
index fceffb3..55a394c 100644
--- a/arch/powerpc/configs/ep8248e_defconfig
+++ b/arch/powerpc/configs/ep8248e_defconfig
@@ -58,7 +58,7 @@ CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 # CONFIG_EXT3_FS_XATTR is not set
 CONFIG_INOTIFY=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_CRAMFS=y
diff --git a/arch/powerpc/configs/mgcoge_defconfig b/arch/powerpc/configs/mgcoge_defconfig
index 8fa84f1..a7ad80c 100644
--- a/arch/powerpc/configs/mgcoge_defconfig
+++ b/arch/powerpc/configs/mgcoge_defconfig
@@ -70,7 +70,7 @@ CONFIG_USB_G_SERIAL=y
 CONFIG_UIO=y
 CONFIG_UIO_PDRV=y
 CONFIG_EXT2_FS=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_JFFS2_FS=y
diff --git a/arch/powerpc/configs/mpc8272_ads_defconfig b/arch/powerpc/configs/mpc8272_ads_defconfig
index 6a22400..893d8b9 100644
--- a/arch/powerpc/configs/mpc8272_ads_defconfig
+++ b/arch/powerpc/configs/mpc8272_ads_defconfig
@@ -65,7 +65,7 @@ CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 CONFIG_INOTIFY=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_CRAMFS=y
diff --git a/arch/powerpc/configs/pasemi_defconfig b/arch/powerpc/configs/pasemi_defconfig
index bd8a6f7..0905445 100644
--- a/arch/powerpc/configs/pasemi_defconfig
+++ b/arch/powerpc/configs/pasemi_defconfig
@@ -156,7 +156,7 @@ CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT2_FS_POSIX_ACL=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_ISO9660_FS=y
 CONFIG_UDF_FS=y
 CONFIG_MSDOS_FS=y
diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
index a73626b..74912c0 100644
--- a/arch/powerpc/configs/pmac32_defconfig
+++ b/arch/powerpc/configs/pmac32_defconfig
@@ -315,7 +315,7 @@ CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT4_FS=y
 CONFIG_INOTIFY=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
index c86fcb9..67a96ac 100644
--- a/arch/powerpc/configs/ppc64_defconfig
+++ b/arch/powerpc/configs/ppc64_defconfig
@@ -351,7 +351,7 @@ CONFIG_XFS_POSIX_ACL=y
 CONFIG_BTRFS_FS=m
 CONFIG_BTRFS_FS_POSIX_ACL=y
 CONFIG_NILFS2_FS=m
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_ISO9660_FS=y
 CONFIG_UDF_FS=m
diff --git a/arch/powerpc/configs/ppc64e_defconfig b/arch/powerpc/configs/ppc64e_defconfig
index 4b20f76..c216d80 100644
--- a/arch/powerpc/configs/ppc64e_defconfig
+++ b/arch/powerpc/configs/ppc64e_defconfig
@@ -273,7 +273,7 @@ CONFIG_JFS_POSIX_ACL=y
 CONFIG_JFS_SECURITY=y
 CONFIG_XFS_FS=m
 CONFIG_XFS_POSIX_ACL=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_ISO9660_FS=y
 CONFIG_UDF_FS=m
 CONFIG_MSDOS_FS=y
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 20ebfaf..c25f597 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -1122,7 +1122,7 @@ CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
 CONFIG_QFMT_V2=y
 CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=m
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_FUSE_FS=m
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
diff --git a/arch/powerpc/configs/pq2fads_defconfig b/arch/powerpc/configs/pq2fads_defconfig
index baad8db..9102a31 100644
--- a/arch/powerpc/configs/pq2fads_defconfig
+++ b/arch/powerpc/configs/pq2fads_defconfig
@@ -69,7 +69,7 @@ CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 CONFIG_INOTIFY=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_CRAMFS=y
diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index 139a830..b34fef3 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -150,7 +150,7 @@ CONFIG_EXT3_FS=m
 CONFIG_EXT4_FS=y
 CONFIG_QUOTA=y
 CONFIG_QFMT_V2=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
 CONFIG_UDF_FS=m
diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index bea8587..b6b835a 100644
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -281,7 +281,7 @@ CONFIG_XFS_POSIX_ACL=y
 CONFIG_BTRFS_FS=m
 CONFIG_BTRFS_FS_POSIX_ACL=y
 CONFIG_NILFS2_FS=m
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=m
 CONFIG_ISO9660_FS=y
 CONFIG_UDF_FS=m
diff --git a/arch/score/configs/spct6600_defconfig b/arch/score/configs/spct6600_defconfig
index df1edbf..dadf48f 100644
--- a/arch/score/configs/spct6600_defconfig
+++ b/arch/score/configs/spct6600_defconfig
@@ -57,7 +57,7 @@ CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_AUTOFS_FS=y
-CONFIG_AUTOFS4_FS=y
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_PROC_KCORE=y
 # CONFIG_PROC_PAGE_MONITOR is not set
 CONFIG_TMPFS=y
diff --git a/arch/sh/configs/espt_defconfig b/arch/sh/configs/espt_defconfig
index 67cb109..491b842 100644
--- a/arch/sh/configs/espt_defconfig
+++ b/arch/sh/configs/espt_defconfig
@@ -74,7 +74,7 @@ CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 CONFIG_AUTOFS_FS=y
-CONFIG_AUTOFS4_FS=y
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
diff --git a/arch/sh/configs/sdk7780_defconfig b/arch/sh/configs/sdk7780_defconfig
index ae11158..ef7736b 100644
--- a/arch/sh/configs/sdk7780_defconfig
+++ b/arch/sh/configs/sdk7780_defconfig
@@ -116,7 +116,7 @@ CONFIG_EXT2_FS_POSIX_ACL=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 CONFIG_EXT3_FS_POSIX_ACL=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_ISO9660_FS=y
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
diff --git a/arch/sh/configs/sdk7786_defconfig b/arch/sh/configs/sdk7786_defconfig
index 76a76a2..3006c56 100644
--- a/arch/sh/configs/sdk7786_defconfig
+++ b/arch/sh/configs/sdk7786_defconfig
@@ -183,7 +183,7 @@ CONFIG_EXT3_FS=y
 CONFIG_EXT4_FS=y
 CONFIG_XFS_FS=y
 CONFIG_BTRFS_FS=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=y
 CONFIG_CUSE=m
 CONFIG_FSCACHE=m
diff --git a/arch/sh/configs/sh03_defconfig b/arch/sh/configs/sh03_defconfig
index 2051821..93b661f 100644
--- a/arch/sh/configs/sh03_defconfig
+++ b/arch/sh/configs/sh03_defconfig
@@ -71,7 +71,7 @@ CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_AUTOFS_FS=y
-CONFIG_AUTOFS4_FS=y
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
 CONFIG_ZISOFS=y
diff --git a/arch/sh/configs/sh7763rdp_defconfig b/arch/sh/configs/sh7763rdp_defconfig
index 4795364..e324b42 100644
--- a/arch/sh/configs/sh7763rdp_defconfig
+++ b/arch/sh/configs/sh7763rdp_defconfig
@@ -75,7 +75,7 @@ CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 CONFIG_AUTOFS_FS=y
-CONFIG_AUTOFS4_FS=y
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_PROC_KCORE=y
diff --git a/arch/sparc/configs/sparc32_defconfig b/arch/sparc/configs/sparc32_defconfig
index fb23fd6..1745260 100644
--- a/arch/sparc/configs/sparc32_defconfig
+++ b/arch/sparc/configs/sparc32_defconfig
@@ -71,7 +71,7 @@ CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT2_FS_POSIX_ACL=y
 CONFIG_EXT2_FS_SECURITY=y
 CONFIG_AUTOFS_FS=m
-CONFIG_AUTOFS4_FS=m
+# CONFIG_AUTOFS4_FS is not set
 CONFIG_ISO9660_FS=m
 CONFIG_PROC_KCORE=y
 CONFIG_ROMFS_FS=m
diff --git a/arch/tile/configs/tilegx_defconfig b/arch/tile/configs/tilegx_defconfig
index 4768481..a8196cf 100644
--- a/arch/tile/configs/tilegx_defconfig
+++ b/arch/tile/configs/tilegx_defconfig
@@ -443,7 +443,7 @@ CONFIG_QUOTA=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
 CONFIG_QFMT_V2=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=y
 CONFIG_CUSE=m
 CONFIG_FSCACHE=m
diff --git a/arch/tile/configs/tilepro_defconfig b/arch/tile/configs/tilepro_defconfig
index dd2b8f0..2fa5f6e 100644
--- a/arch/tile/configs/tilepro_defconfig
+++ b/arch/tile/configs/tilepro_defconfig
@@ -431,7 +431,7 @@ CONFIG_QUOTA=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
 CONFIG_QFMT_V2=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 CONFIG_FUSE_FS=y
 CONFIG_CUSE=m
 CONFIG_FSCACHE=m
diff --git a/arch/um/defconfig b/arch/um/defconfig
index 08107a7..9c13ef8 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -607,7 +607,7 @@ CONFIG_PRINT_QUOTA_WARNING=y
 # CONFIG_QFMT_V1 is not set
 # CONFIG_QFMT_V2 is not set
 CONFIG_QUOTACTL=y
-CONFIG_AUTOFS4_FS=m
+CONFIG_AUTOFS_FS=m
 # CONFIG_FUSE_FS is not set
 
 #
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 9444708..d28fc1f 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -266,7 +266,7 @@ CONFIG_QUOTA=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
 CONFIG_QFMT_V2=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
 CONFIG_ZISOFS=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 671524d..d702451 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -265,7 +265,7 @@ CONFIG_QUOTA=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
 CONFIG_QFMT_V2=y
-CONFIG_AUTOFS4_FS=y
+CONFIG_AUTOFS_FS=y
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
 CONFIG_ZISOFS=y
diff --git a/arch/xtensa/configs/common_defconfig b/arch/xtensa/configs/common_defconfig
index a182a4e..2fe8b64 100644
--- a/arch/xtensa/configs/common_defconfig
+++ b/arch/xtensa/configs/common_defconfig
@@ -543,7 +543,6 @@ CONFIG_USB_ARCH_HAS_OHCI=y
 # CONFIG_QUOTA is not set
 CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
-# CONFIG_AUTOFS4_FS is not set
 
 #
 # CD-ROM/DVD Filesystems
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index 77c52f8..5ae3369 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -523,7 +523,6 @@ CONFIG_FSNOTIFY=y
 CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 # CONFIG_AUTOFS_FS is not set
-# CONFIG_AUTOFS4_FS is not set
 # CONFIG_FUSE_FS is not set
 
 #
diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 4799c6a..cf5fd90 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -503,7 +503,6 @@ CONFIG_FILE_LOCKING=y
 # CONFIG_INOTIFY is not set
 # CONFIG_QUOTA is not set
 # CONFIG_AUTOFS_FS is not set
-# CONFIG_AUTOFS4_FS is not set
 # CONFIG_FUSE_FS is not set
 
 #

