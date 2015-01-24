Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbbAXQeW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 11:34:22 -0500
Received: from exprod5og125.obsmtp.com ([64.18.0.245]:56295 "EHLO
	exprod5og125.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbbAXQeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 11:34:15 -0500
From: Semen Protsenko <semen.protsenko@globallogic.com>
To: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: adi-buildroot-devel@lists.sourceforge.net, linux-am33-list@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org
Subject: [PATCH 2/4] defconfigs: remove CONFIG_MTD_PARTITIONS
Date: Sat, 24 Jan 2015 18:33:31 +0200
Message-Id: <1422117213-3130-3-git-send-email-semen.protsenko@globallogic.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422117213-3130-1-git-send-email-semen.protsenko@globallogic.com>
References: <1422117213-3130-1-git-send-email-semen.protsenko@globallogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_MTD_PARTITIONS was removed from drivers/mtd/Kconfig by commit:
6a8a98b22b10 "mtd: kill CONFIG_MTD_PARTITIONS".

This patch finishes job by getting rid of CONFIG_MTD_PARTITIONS in all
defconfig files.

This patch is harmless for all modified defconfig files, because
MTD_PARTITIONS code is now compiled without checking for
CONFIG_MTD_PARTITIONS. For details see next commit:
5fcb033159bc "mtd: always build partitioning support".

Signed-off-by: Semen Protsenko <semen.protsenko@globallogic.com>
---
 arch/arm/configs/acs5k_defconfig           |    1 -
 arch/arm/configs/acs5k_tiny_defconfig      |    1 -
 arch/arm/configs/assabet_defconfig         |    1 -
 arch/arm/configs/badge4_defconfig          |    1 -
 arch/arm/configs/cerfcube_defconfig        |    1 -
 arch/arm/configs/cm_x300_defconfig         |    1 -
 arch/arm/configs/cns3420vb_defconfig       |    1 -
 arch/arm/configs/collie_defconfig          |    1 -
 arch/arm/configs/corgi_defconfig           |    1 -
 arch/arm/configs/davinci_all_defconfig     |    1 -
 arch/arm/configs/h5000_defconfig           |    1 -
 arch/arm/configs/iop13xx_defconfig         |    1 -
 arch/arm/configs/iop32x_defconfig          |    1 -
 arch/arm/configs/iop33x_defconfig          |    1 -
 arch/arm/configs/ixp4xx_defconfig          |    1 -
 arch/arm/configs/ks8695_defconfig          |    1 -
 arch/arm/configs/lart_defconfig            |    1 -
 arch/arm/configs/lpd270_defconfig          |    1 -
 arch/arm/configs/lubbock_defconfig         |    1 -
 arch/arm/configs/mackerel_defconfig        |    1 -
 arch/arm/configs/magician_defconfig        |    1 -
 arch/arm/configs/mainstone_defconfig       |    1 -
 arch/arm/configs/mini2440_defconfig        |    1 -
 arch/arm/configs/mv78xx0_defconfig         |    1 -
 arch/arm/configs/neponset_defconfig        |    1 -
 arch/arm/configs/netx_defconfig            |    1 -
 arch/arm/configs/nuc910_defconfig          |    1 -
 arch/arm/configs/nuc950_defconfig          |    1 -
 arch/arm/configs/nuc960_defconfig          |    1 -
 arch/arm/configs/omap1_defconfig           |    1 -
 arch/arm/configs/pcm027_defconfig          |    1 -
 arch/arm/configs/pleb_defconfig            |    1 -
 arch/arm/configs/pxa255-idp_defconfig      |    1 -
 arch/arm/configs/raumfeld_defconfig        |    1 -
 arch/arm/configs/realview-smp_defconfig    |    1 -
 arch/arm/configs/realview_defconfig        |    1 -
 arch/arm/configs/shannon_defconfig         |    1 -
 arch/arm/configs/simpad_defconfig          |    1 -
 arch/arm/configs/spitz_defconfig           |    1 -
 arch/arm/configs/tct_hammer_defconfig      |    1 -
 arch/m32r/configs/m32700ut.smp_defconfig   |    1 -
 arch/m32r/configs/m32700ut.up_defconfig    |    1 -
 arch/m32r/configs/mappi.smp_defconfig      |    1 -
 arch/m32r/configs/mappi.up_defconfig       |    1 -
 arch/m32r/configs/mappi3.smp_defconfig     |    1 -
 arch/m32r/configs/usrv_defconfig           |    1 -
 arch/mn10300/configs/asb2303_defconfig     |    1 -
 arch/mn10300/configs/asb2364_defconfig     |    1 -
 arch/sh/configs/ap325rxa_defconfig         |    1 -
 arch/sh/configs/apsh4a3a_defconfig         |    1 -
 arch/sh/configs/ecovec24_defconfig         |    1 -
 arch/sh/configs/edosk7760_defconfig        |    1 -
 arch/sh/configs/espt_defconfig             |    1 -
 arch/sh/configs/magicpanelr2_defconfig     |    1 -
 arch/sh/configs/migor_defconfig            |    1 -
 arch/sh/configs/polaris_defconfig          |    1 -
 arch/sh/configs/r7780mp_defconfig          |    1 -
 arch/sh/configs/rsk7201_defconfig          |    1 -
 arch/sh/configs/rsk7203_defconfig          |    1 -
 arch/sh/configs/rts7751r2dplus_defconfig   |    1 -
 arch/sh/configs/sdk7786_defconfig          |    1 -
 arch/sh/configs/se7206_defconfig           |    1 -
 arch/sh/configs/se7343_defconfig           |    1 -
 arch/sh/configs/se7619_defconfig           |    1 -
 arch/sh/configs/se7705_defconfig           |    1 -
 arch/sh/configs/se7712_defconfig           |    1 -
 arch/sh/configs/se7721_defconfig           |    1 -
 arch/sh/configs/se7724_defconfig           |    1 -
 arch/sh/configs/se7750_defconfig           |    1 -
 arch/sh/configs/se7751_defconfig           |    1 -
 arch/sh/configs/se7780_defconfig           |    1 -
 arch/sh/configs/secureedge5410_defconfig   |    1 -
 arch/sh/configs/sh7710voipgw_defconfig     |    1 -
 arch/sh/configs/sh7763rdp_defconfig        |    1 -
 arch/sh/configs/sh7785lcr_32bit_defconfig  |    1 -
 arch/sh/configs/sh7785lcr_defconfig        |    1 -
 arch/sh/configs/shmin_defconfig            |    1 -
 arch/sh/configs/ul2_defconfig              |    1 -
 arch/sh/configs/urquell_defconfig          |    1 -
 arch/unicore32/configs/unicore32_defconfig |    1 -
 80 files changed, 80 deletions(-)

diff --git a/arch/arm/configs/acs5k_defconfig b/arch/arm/configs/acs5k_defconfig
index b8be0bc..4faff9a 100644
--- a/arch/arm/configs/acs5k_defconfig
+++ b/arch/arm/configs/acs5k_defconfig
@@ -34,7 +34,6 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/acs5k_tiny_defconfig b/arch/arm/configs/acs5k_tiny_defconfig
index 886448a..71c356f 100644
--- a/arch/arm/configs/acs5k_tiny_defconfig
+++ b/arch/arm/configs/acs5k_tiny_defconfig
@@ -29,7 +29,6 @@ CONFIG_INET=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/assabet_defconfig b/arch/arm/configs/assabet_defconfig
index 558ecd8..bdf6f9c 100644
--- a/arch/arm/configs/assabet_defconfig
+++ b/arch/arm/configs/assabet_defconfig
@@ -22,7 +22,6 @@ CONFIG_IRDA=m
 CONFIG_IRLAN=m
 CONFIG_SA1100_FIR=m
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/badge4_defconfig b/arch/arm/configs/badge4_defconfig
index 0494c8f..853cd3f 100644
--- a/arch/arm/configs/badge4_defconfig
+++ b/arch/arm/configs/badge4_defconfig
@@ -30,7 +30,6 @@ CONFIG_BT_HCIVHCI=m
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/cerfcube_defconfig b/arch/arm/configs/cerfcube_defconfig
index dce912d..dcee643 100644
--- a/arch/arm/configs/cerfcube_defconfig
+++ b/arch/arm/configs/cerfcube_defconfig
@@ -29,7 +29,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_IP_PNP_RARP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=m
diff --git a/arch/arm/configs/cm_x300_defconfig b/arch/arm/configs/cm_x300_defconfig
index 7df040e..8b3b76d 100644
--- a/arch/arm/configs/cm_x300_defconfig
+++ b/arch/arm/configs/cm_x300_defconfig
@@ -51,7 +51,6 @@ CONFIG_BT_HCIBTUSB=m
 CONFIG_LIB80211=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_NAND=y
diff --git a/arch/arm/configs/cns3420vb_defconfig b/arch/arm/configs/cns3420vb_defconfig
index b1ff5cd..e5f02de 100644
--- a/arch/arm/configs/cns3420vb_defconfig
+++ b/arch/arm/configs/cns3420vb_defconfig
@@ -31,7 +31,6 @@ CONFIG_CMDLINE="console=ttyS0,38400 mem=128M root=/dev/mmcblk0p1 ro rootwait"
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/collie_defconfig b/arch/arm/configs/collie_defconfig
index 6c56ad0..4fff4ea 100644
--- a/arch/arm/configs/collie_defconfig
+++ b/arch/arm/configs/collie_defconfig
@@ -26,7 +26,6 @@ CONFIG_UNIX=y
 CONFIG_INET=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/corgi_defconfig b/arch/arm/configs/corgi_defconfig
index c1470a0..37b6e0d 100644
--- a/arch/arm/configs/corgi_defconfig
+++ b/arch/arm/configs/corgi_defconfig
@@ -90,7 +90,6 @@ CONFIG_BT_HCIBTUART=m
 CONFIG_BT_HCIVHCI=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/davinci_all_defconfig b/arch/arm/configs/davinci_all_defconfig
index 235842c..6beeaeb 100644
--- a/arch/arm/configs/davinci_all_defconfig
+++ b/arch/arm/configs/davinci_all_defconfig
@@ -63,7 +63,6 @@ CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=m
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=m
 CONFIG_MTD_BLOCK=m
 CONFIG_MTD_CFI=m
diff --git a/arch/arm/configs/h5000_defconfig b/arch/arm/configs/h5000_defconfig
index 37903e3..68703a5 100644
--- a/arch/arm/configs/h5000_defconfig
+++ b/arch/arm/configs/h5000_defconfig
@@ -36,7 +36,6 @@ CONFIG_IP_PNP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_ADV_OPTIONS=y
diff --git a/arch/arm/configs/iop13xx_defconfig b/arch/arm/configs/iop13xx_defconfig
index 4fa94a1..6de6017 100644
--- a/arch/arm/configs/iop13xx_defconfig
+++ b/arch/arm/configs/iop13xx_defconfig
@@ -38,7 +38,6 @@ CONFIG_IPV6=y
 # CONFIG_IPV6_SIT is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
 CONFIG_MTD_REDBOOT_PARTS_READONLY=y
diff --git a/arch/arm/configs/iop32x_defconfig b/arch/arm/configs/iop32x_defconfig
index 4f2ec3a..c18ee5b 100644
--- a/arch/arm/configs/iop32x_defconfig
+++ b/arch/arm/configs/iop32x_defconfig
@@ -34,7 +34,6 @@ CONFIG_IPV6=y
 # CONFIG_IPV6_SIT is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
 CONFIG_MTD_REDBOOT_PARTS_READONLY=y
diff --git a/arch/arm/configs/iop33x_defconfig b/arch/arm/configs/iop33x_defconfig
index aa36128..e2304e4 100644
--- a/arch/arm/configs/iop33x_defconfig
+++ b/arch/arm/configs/iop33x_defconfig
@@ -32,7 +32,6 @@ CONFIG_IPV6=y
 # CONFIG_IPV6_SIT is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
 CONFIG_MTD_REDBOOT_PARTS_READONLY=y
diff --git a/arch/arm/configs/ixp4xx_defconfig b/arch/arm/configs/ixp4xx_defconfig
index 1af665e..1b45fb6 100644
--- a/arch/arm/configs/ixp4xx_defconfig
+++ b/arch/arm/configs/ixp4xx_defconfig
@@ -114,7 +114,6 @@ CONFIG_NET_ACT_POLICE=y
 CONFIG_NET_PKTGEN=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/ks8695_defconfig b/arch/arm/configs/ks8695_defconfig
index 47c4883..c58fc9a 100644
--- a/arch/arm/configs/ks8695_defconfig
+++ b/arch/arm/configs/ks8695_defconfig
@@ -32,7 +32,6 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/arm/configs/lart_defconfig b/arch/arm/configs/lart_defconfig
index faa2865..3ae0387 100644
--- a/arch/arm/configs/lart_defconfig
+++ b/arch/arm/configs/lart_defconfig
@@ -31,7 +31,6 @@ CONFIG_SA1100_FIR=m
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
 CONFIG_MTD_DEBUG_VERBOSE=1
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_LART=y
diff --git a/arch/arm/configs/lpd270_defconfig b/arch/arm/configs/lpd270_defconfig
index 1c8c9ee..2e1c520 100644
--- a/arch/arm/configs/lpd270_defconfig
+++ b/arch/arm/configs/lpd270_defconfig
@@ -21,7 +21,6 @@ CONFIG_IPV6=y
 # CONFIG_INET6_XFRM_MODE_BEET is not set
 # CONFIG_IPV6_SIT is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/lubbock_defconfig b/arch/arm/configs/lubbock_defconfig
index c4ba274..198d7c3 100644
--- a/arch/arm/configs/lubbock_defconfig
+++ b/arch/arm/configs/lubbock_defconfig
@@ -20,7 +20,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_BOOTP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/mackerel_defconfig b/arch/arm/configs/mackerel_defconfig
index 5c38517..821d4c0 100644
--- a/arch/arm/configs/mackerel_defconfig
+++ b/arch/arm/configs/mackerel_defconfig
@@ -45,7 +45,6 @@ CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/magician_defconfig b/arch/arm/configs/magician_defconfig
index 557dd29..59f7e6a 100644
--- a/arch/arm/configs/magician_defconfig
+++ b/arch/arm/configs/magician_defconfig
@@ -60,7 +60,6 @@ CONFIG_BT_HCIBTUSB=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/mainstone_defconfig b/arch/arm/configs/mainstone_defconfig
index 04efa1b..289d20a 100644
--- a/arch/arm/configs/mainstone_defconfig
+++ b/arch/arm/configs/mainstone_defconfig
@@ -18,7 +18,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_BOOTP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/mini2440_defconfig b/arch/arm/configs/mini2440_defconfig
index 26b12e8..ea634d7 100644
--- a/arch/arm/configs/mini2440_defconfig
+++ b/arch/arm/configs/mini2440_defconfig
@@ -85,7 +85,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_CONNECTOR=m
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/mv78xx0_defconfig b/arch/arm/configs/mv78xx0_defconfig
index 0dae1c1..eb2f489 100644
--- a/arch/arm/configs/mv78xx0_defconfig
+++ b/arch/arm/configs/mv78xx0_defconfig
@@ -37,7 +37,6 @@ CONFIG_NET_PKTGEN=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/neponset_defconfig b/arch/arm/configs/neponset_defconfig
index 4b77dc3..5c0a754 100644
--- a/arch/arm/configs/neponset_defconfig
+++ b/arch/arm/configs/neponset_defconfig
@@ -25,7 +25,6 @@ CONFIG_UNIX=y
 CONFIG_INET=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/netx_defconfig b/arch/arm/configs/netx_defconfig
index 9c0ad79..81b6225 100644
--- a/arch/arm/configs/netx_defconfig
+++ b/arch/arm/configs/netx_defconfig
@@ -37,7 +37,6 @@ CONFIG_NETFILTER=y
 CONFIG_IP_NF_QUEUE=m
 CONFIG_NET_PKTGEN=m
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/nuc910_defconfig b/arch/arm/configs/nuc910_defconfig
index c178636..6fd91ad 100644
--- a/arch/arm/configs/nuc910_defconfig
+++ b/arch/arm/configs/nuc910_defconfig
@@ -16,7 +16,6 @@ CONFIG_KEXEC=y
 CONFIG_FPE_NWFPE=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/nuc950_defconfig b/arch/arm/configs/nuc950_defconfig
index 10d7cee..f06fe4f 100644
--- a/arch/arm/configs/nuc950_defconfig
+++ b/arch/arm/configs/nuc950_defconfig
@@ -22,7 +22,6 @@ CONFIG_BINFMT_AOUT=y
 CONFIG_BINFMT_MISC=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/nuc960_defconfig b/arch/arm/configs/nuc960_defconfig
index b51afd2..cb45952 100644
--- a/arch/arm/configs/nuc960_defconfig
+++ b/arch/arm/configs/nuc960_defconfig
@@ -22,7 +22,6 @@ CONFIG_BINFMT_AOUT=y
 CONFIG_BINFMT_MISC=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
index a7dce67..0834eb9 100644
--- a/arch/arm/configs/omap1_defconfig
+++ b/arch/arm/configs/omap1_defconfig
@@ -94,7 +94,6 @@ CONFIG_CONNECTOR=y
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
 CONFIG_MTD_DEBUG_VERBOSE=3
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/pcm027_defconfig b/arch/arm/configs/pcm027_defconfig
index 0a847d0..03c4919 100644
--- a/arch/arm/configs/pcm027_defconfig
+++ b/arch/arm/configs/pcm027_defconfig
@@ -39,7 +39,6 @@ CONFIG_IP_PNP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/pleb_defconfig b/arch/arm/configs/pleb_defconfig
index cb08cc5..7ad5c8e 100644
--- a/arch/arm/configs/pleb_defconfig
+++ b/arch/arm/configs/pleb_defconfig
@@ -24,7 +24,6 @@ CONFIG_INET=y
 CONFIG_SYN_COOKIES=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
 CONFIG_MTD_CMDLINE_PARTS=y
diff --git a/arch/arm/configs/pxa255-idp_defconfig b/arch/arm/configs/pxa255-idp_defconfig
index 917a070..eb35347 100644
--- a/arch/arm/configs/pxa255-idp_defconfig
+++ b/arch/arm/configs/pxa255-idp_defconfig
@@ -18,7 +18,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/raumfeld_defconfig b/arch/arm/configs/raumfeld_defconfig
index b7180b9..4eb3237 100644
--- a/arch/arm/configs/raumfeld_defconfig
+++ b/arch/arm/configs/raumfeld_defconfig
@@ -31,7 +31,6 @@ CONFIG_CFG80211_REG_DEBUG=y
 CONFIG_MAC80211=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_NFTL=y
diff --git a/arch/arm/configs/realview-smp_defconfig b/arch/arm/configs/realview-smp_defconfig
index 377253e..f2ebbd9 100644
--- a/arch/arm/configs/realview-smp_defconfig
+++ b/arch/arm/configs/realview-smp_defconfig
@@ -30,7 +30,6 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/realview_defconfig b/arch/arm/configs/realview_defconfig
index 536a3e0..5af8de1 100644
--- a/arch/arm/configs/realview_defconfig
+++ b/arch/arm/configs/realview_defconfig
@@ -29,7 +29,6 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/shannon_defconfig b/arch/arm/configs/shannon_defconfig
index b0b9694..aa8ffd6 100644
--- a/arch/arm/configs/shannon_defconfig
+++ b/arch/arm/configs/shannon_defconfig
@@ -17,7 +17,6 @@ CONFIG_UNIX=y
 CONFIG_INET=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/simpad_defconfig b/arch/arm/configs/simpad_defconfig
index e7aadaa..2232927 100644
--- a/arch/arm/configs/simpad_defconfig
+++ b/arch/arm/configs/simpad_defconfig
@@ -41,7 +41,6 @@ CONFIG_BT_BNEP=m
 CONFIG_BT_BNEP_MC_FILTER=y
 CONFIG_BT_BNEP_PROTO_FILTER=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
index a1ede19..fb617d2 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -87,7 +87,6 @@ CONFIG_BT_HCIBTUART=m
 CONFIG_BT_HCIVHCI=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/tct_hammer_defconfig b/arch/arm/configs/tct_hammer_defconfig
index 7209a2c..4829499 100644
--- a/arch/arm/configs/tct_hammer_defconfig
+++ b/arch/arm/configs/tct_hammer_defconfig
@@ -26,7 +26,6 @@ CONFIG_UNIX=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/m32r/configs/m32700ut.smp_defconfig b/arch/m32r/configs/m32700ut.smp_defconfig
index a3d727e..fe09039 100644
--- a/arch/m32r/configs/m32700ut.smp_defconfig
+++ b/arch/m32r/configs/m32700ut.smp_defconfig
@@ -30,7 +30,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=m
diff --git a/arch/m32r/configs/m32700ut.up_defconfig b/arch/m32r/configs/m32700ut.up_defconfig
index b833416..18091bf 100644
--- a/arch/m32r/configs/m32700ut.up_defconfig
+++ b/arch/m32r/configs/m32700ut.up_defconfig
@@ -29,7 +29,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=m
diff --git a/arch/m32r/configs/mappi.smp_defconfig b/arch/m32r/configs/mappi.smp_defconfig
index 367d07c..109409b 100644
--- a/arch/m32r/configs/mappi.smp_defconfig
+++ b/arch/m32r/configs/mappi.smp_defconfig
@@ -31,7 +31,6 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 # CONFIG_STANDALONE is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/m32r/configs/mappi.up_defconfig b/arch/m32r/configs/mappi.up_defconfig
index cb11384..74d5a23 100644
--- a/arch/m32r/configs/mappi.up_defconfig
+++ b/arch/m32r/configs/mappi.up_defconfig
@@ -29,7 +29,6 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 # CONFIG_STANDALONE is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/m32r/configs/mappi3.smp_defconfig b/arch/m32r/configs/mappi3.smp_defconfig
index 27cefd4..f030ddd 100644
--- a/arch/m32r/configs/mappi3.smp_defconfig
+++ b/arch/m32r/configs/mappi3.smp_defconfig
@@ -29,7 +29,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/m32r/configs/usrv_defconfig b/arch/m32r/configs/usrv_defconfig
index 818fe33..7f6d680 100644
--- a/arch/m32r/configs/usrv_defconfig
+++ b/arch/m32r/configs/usrv_defconfig
@@ -34,7 +34,6 @@ CONFIG_INET_ESP=y
 CONFIG_INET_IPCOMP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/mn10300/configs/asb2303_defconfig b/arch/mn10300/configs/asb2303_defconfig
index 1fd41ec..591ab65 100644
--- a/arch/mn10300/configs/asb2303_defconfig
+++ b/arch/mn10300/configs/asb2303_defconfig
@@ -34,7 +34,6 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_WIRELESS is not set
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/mn10300/configs/asb2364_defconfig b/arch/mn10300/configs/asb2364_defconfig
index fbb96ae..fbaac16 100644
--- a/arch/mn10300/configs/asb2364_defconfig
+++ b/arch/mn10300/configs/asb2364_defconfig
@@ -51,7 +51,6 @@ CONFIG_IPV6=y
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/sh/configs/ap325rxa_defconfig b/arch/sh/configs/ap325rxa_defconfig
index 67afc82..667f79b 100644
--- a/arch/sh/configs/ap325rxa_defconfig
+++ b/arch/sh/configs/ap325rxa_defconfig
@@ -32,7 +32,6 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/sh/configs/apsh4a3a_defconfig b/arch/sh/configs/apsh4a3a_defconfig
index 26fb9e9..88da509 100644
--- a/arch/sh/configs/apsh4a3a_defconfig
+++ b/arch/sh/configs/apsh4a3a_defconfig
@@ -34,7 +34,6 @@ CONFIG_IP_PNP_DHCP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/ecovec24_defconfig b/arch/sh/configs/ecovec24_defconfig
index ef13931..2baca9b 100644
--- a/arch/sh/configs/ecovec24_defconfig
+++ b/arch/sh/configs/ecovec24_defconfig
@@ -35,7 +35,6 @@ CONFIG_IRDA=y
 CONFIG_SH_SIR=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/sh/configs/edosk7760_defconfig b/arch/sh/configs/edosk7760_defconfig
index 89defd1..d4a6929 100644
--- a/arch/sh/configs/edosk7760_defconfig
+++ b/arch/sh/configs/edosk7760_defconfig
@@ -39,7 +39,6 @@ CONFIG_DEBUG_DRIVER=y
 CONFIG_DEBUG_DEVRES=y
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/sh/configs/espt_defconfig b/arch/sh/configs/espt_defconfig
index 67cb109..1d9d673 100644
--- a/arch/sh/configs/espt_defconfig
+++ b/arch/sh/configs/espt_defconfig
@@ -30,7 +30,6 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/sh/configs/magicpanelr2_defconfig b/arch/sh/configs/magicpanelr2_defconfig
index 9479872..e660804 100644
--- a/arch/sh/configs/magicpanelr2_defconfig
+++ b/arch/sh/configs/magicpanelr2_defconfig
@@ -41,7 +41,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_STANDALONE is not set
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/sh/configs/migor_defconfig b/arch/sh/configs/migor_defconfig
index c2c4a67..ba1e58d 100644
--- a/arch/sh/configs/migor_defconfig
+++ b/arch/sh/configs/migor_defconfig
@@ -31,7 +31,6 @@ CONFIG_IP_PNP_DHCP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_FW_LOADER=m
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/sh/configs/polaris_defconfig b/arch/sh/configs/polaris_defconfig
index f3d5d9f..d2bfd3a 100644
--- a/arch/sh/configs/polaris_defconfig
+++ b/arch/sh/configs/polaris_defconfig
@@ -42,7 +42,6 @@ CONFIG_IP_MULTICAST=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/sh/configs/r7780mp_defconfig b/arch/sh/configs/r7780mp_defconfig
index 920b847..0e7028c 100644
--- a/arch/sh/configs/r7780mp_defconfig
+++ b/arch/sh/configs/r7780mp_defconfig
@@ -41,7 +41,6 @@ CONFIG_BRIDGE=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_FW_LOADER=m
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_COMPLEX_MAPPINGS=y
diff --git a/arch/sh/configs/rsk7201_defconfig b/arch/sh/configs/rsk7201_defconfig
index 82fca50..b8c30c4 100644
--- a/arch/sh/configs/rsk7201_defconfig
+++ b/arch/sh/configs/rsk7201_defconfig
@@ -37,7 +37,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/sh/configs/rsk7203_defconfig b/arch/sh/configs/rsk7203_defconfig
index 26f7e8c..fe0c85f 100644
--- a/arch/sh/configs/rsk7203_defconfig
+++ b/arch/sh/configs/rsk7203_defconfig
@@ -52,7 +52,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/sh/configs/rts7751r2dplus_defconfig b/arch/sh/configs/rts7751r2dplus_defconfig
index 9f5fd0b..1f909c3 100644
--- a/arch/sh/configs/rts7751r2dplus_defconfig
+++ b/arch/sh/configs/rts7751r2dplus_defconfig
@@ -27,7 +27,6 @@ CONFIG_INET=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_FW_LOADER=m
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/sdk7786_defconfig b/arch/sh/configs/sdk7786_defconfig
index e7e56a4..c463a8d 100644
--- a/arch/sh/configs/sdk7786_defconfig
+++ b/arch/sh/configs/sdk7786_defconfig
@@ -97,7 +97,6 @@ CONFIG_IP_PNP_DHCP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_BLOCK=y
 CONFIG_FTL=y
diff --git a/arch/sh/configs/se7206_defconfig b/arch/sh/configs/se7206_defconfig
index f111e63..d4acb86 100644
--- a/arch/sh/configs/se7206_defconfig
+++ b/arch/sh/configs/se7206_defconfig
@@ -66,7 +66,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/se7343_defconfig b/arch/sh/configs/se7343_defconfig
index 89dd658..d2a2763 100644
--- a/arch/sh/configs/se7343_defconfig
+++ b/arch/sh/configs/se7343_defconfig
@@ -32,7 +32,6 @@ CONFIG_SYN_COOKIES=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/se7619_defconfig b/arch/sh/configs/se7619_defconfig
index ebc7e21..6e0fded 100644
--- a/arch/sh/configs/se7619_defconfig
+++ b/arch/sh/configs/se7619_defconfig
@@ -24,7 +24,6 @@ CONFIG_BINFMT_ZFLAT=y
 # CONFIG_STANDALONE is not set
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/sh/configs/se7705_defconfig b/arch/sh/configs/se7705_defconfig
index 044e084..443d111 100644
--- a/arch/sh/configs/se7705_defconfig
+++ b/arch/sh/configs/se7705_defconfig
@@ -30,7 +30,6 @@ CONFIG_IP_PNP_RARP=y
 # CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/se7712_defconfig b/arch/sh/configs/se7712_defconfig
index 53361a9..a5bc506 100644
--- a/arch/sh/configs/se7712_defconfig
+++ b/arch/sh/configs/se7712_defconfig
@@ -68,7 +68,6 @@ CONFIG_NET_CLS_FW=y
 CONFIG_NET_CLS_IND=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/se7721_defconfig b/arch/sh/configs/se7721_defconfig
index 9d293c2..e9bb439 100644
--- a/arch/sh/configs/se7721_defconfig
+++ b/arch/sh/configs/se7721_defconfig
@@ -67,7 +67,6 @@ CONFIG_NET_CLS_FW=y
 CONFIG_NET_CLS_IND=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/se7724_defconfig b/arch/sh/configs/se7724_defconfig
index dded704..470af81 100644
--- a/arch/sh/configs/se7724_defconfig
+++ b/arch/sh/configs/se7724_defconfig
@@ -34,7 +34,6 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/sh/configs/se7750_defconfig b/arch/sh/configs/se7750_defconfig
index 912c985..56ce93c 100644
--- a/arch/sh/configs/se7750_defconfig
+++ b/arch/sh/configs/se7750_defconfig
@@ -28,7 +28,6 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/se7751_defconfig b/arch/sh/configs/se7751_defconfig
index 75c92fc..1cd2aaf 100644
--- a/arch/sh/configs/se7751_defconfig
+++ b/arch/sh/configs/se7751_defconfig
@@ -31,7 +31,6 @@ CONFIG_NETFILTER=y
 CONFIG_NETFILTER_DEBUG=y
 CONFIG_IP_NF_QUEUE=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
diff --git a/arch/sh/configs/se7780_defconfig b/arch/sh/configs/se7780_defconfig
index b0ef63c..560dc25 100644
--- a/arch/sh/configs/se7780_defconfig
+++ b/arch/sh/configs/se7780_defconfig
@@ -32,7 +32,6 @@ CONFIG_IPV6=y
 # CONFIG_IPV6_SIT is not set
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/secureedge5410_defconfig b/arch/sh/configs/secureedge5410_defconfig
index 7eae4e5..32a30d0 100644
--- a/arch/sh/configs/secureedge5410_defconfig
+++ b/arch/sh/configs/secureedge5410_defconfig
@@ -22,7 +22,6 @@ CONFIG_INET=y
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK_RO=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/sh7710voipgw_defconfig b/arch/sh/configs/sh7710voipgw_defconfig
index f92ad17..1b48f4e 100644
--- a/arch/sh/configs/sh7710voipgw_defconfig
+++ b/arch/sh/configs/sh7710voipgw_defconfig
@@ -36,7 +36,6 @@ CONFIG_NET_CLS_ROUTE4=y
 CONFIG_NET_CLS_U32=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/sh7763rdp_defconfig b/arch/sh/configs/sh7763rdp_defconfig
index 4795364..93f37ff 100644
--- a/arch/sh/configs/sh7763rdp_defconfig
+++ b/arch/sh/configs/sh7763rdp_defconfig
@@ -30,7 +30,6 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_BLKDEVS=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/sh7785lcr_32bit_defconfig b/arch/sh/configs/sh7785lcr_32bit_defconfig
index 1f136ac..ac947d4 100644
--- a/arch/sh/configs/sh7785lcr_32bit_defconfig
+++ b/arch/sh/configs/sh7785lcr_32bit_defconfig
@@ -48,7 +48,6 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/sh7785lcr_defconfig b/arch/sh/configs/sh7785lcr_defconfig
index 69b2facb..66f5c96 100644
--- a/arch/sh/configs/sh7785lcr_defconfig
+++ b/arch/sh/configs/sh7785lcr_defconfig
@@ -31,7 +31,6 @@ CONFIG_IP_PNP_DHCP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/shmin_defconfig b/arch/sh/configs/shmin_defconfig
index 4802e14..339c0e3 100644
--- a/arch/sh/configs/shmin_defconfig
+++ b/arch/sh/configs/shmin_defconfig
@@ -31,7 +31,6 @@ CONFIG_IP_PNP=y
 # CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/ul2_defconfig b/arch/sh/configs/ul2_defconfig
index 3893af6..414246d 100644
--- a/arch/sh/configs/ul2_defconfig
+++ b/arch/sh/configs/ul2_defconfig
@@ -37,7 +37,6 @@ CONFIG_MAC80211_RC_PID=y
 # CONFIG_MAC80211_RC_MINSTREL is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/sh/configs/urquell_defconfig b/arch/sh/configs/urquell_defconfig
index 627d65c..01f4b19 100644
--- a/arch/sh/configs/urquell_defconfig
+++ b/arch/sh/configs/urquell_defconfig
@@ -52,7 +52,6 @@ CONFIG_IP_PNP_DHCP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/unicore32/configs/unicore32_defconfig b/arch/unicore32/configs/unicore32_defconfig
index 45f47f8..43399f1 100644
--- a/arch/unicore32/configs/unicore32_defconfig
+++ b/arch/unicore32/configs/unicore32_defconfig
@@ -75,7 +75,6 @@ CONFIG_PUV3_UART=n
 #	Memory Technology Device (MTD) support
 CONFIG_MTD=m
 CONFIG_MTD_UBI=m
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=m
 CONFIG_MTD_BLKDEVS=m
 #	RAM/ROM/Flash chip drivers
-- 
1.7.9.5

