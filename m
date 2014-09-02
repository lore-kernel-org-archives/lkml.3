Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaIBIu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:50:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36161 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753212AbaIBIuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:50:23 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 7/7] ARM: at91: sama5: update defconfig
Date: Tue,  2 Sep 2014 10:50:03 +0200
Message-Id: <1409647803-8054-8-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409647803-8054-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1409647803-8054-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update defconfig, adding:
 - PWM support using the generic framework
 - generic PWM leds
 - Power/reset

and removing deprecated config options.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/configs/sama5_defconfig | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
index 4414990521d3..eaff1292d09f 100644
--- a/arch/arm/configs/sama5_defconfig
+++ b/arch/arm/configs/sama5_defconfig
@@ -21,7 +21,6 @@ CONFIG_SOC_SAM_V7=y
 CONFIG_SOC_SAMA5D3=y
 CONFIG_MACH_SAMA5_DT=y
 CONFIG_AEABI=y
-# CONFIG_OABI_COMPAT is not set
 CONFIG_UACCESS_WITH_MEMCPY=y
 CONFIG_ZBOOT_ROM_TEXT=0x0
 CONFIG_ZBOOT_ROM_BSS=0x0
@@ -65,7 +64,6 @@ CONFIG_DEVTMPFS_MOUNT=y
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_MTD=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_M25P80=y
@@ -73,7 +71,6 @@ CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ATMEL=y
 CONFIG_MTD_UBI=y
 CONFIG_MTD_UBI_GLUEBI=y
-CONFIG_PROC_DEVICETREE=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=4
@@ -83,10 +80,8 @@ CONFIG_ATMEL_SSC=y
 CONFIG_EEPROM_AT24=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
-CONFIG_SCSI_MULTI_LUN=y
 # CONFIG_SCSI_LOWLEVEL is not set
 CONFIG_NETDEVICES=y
-CONFIG_MII=y
 CONFIG_MACB=y
 # CONFIG_NET_VENDOR_BROADCOM is not set
 # CONFIG_NET_VENDOR_CIRRUS is not set
@@ -135,6 +130,8 @@ CONFIG_SPI=y
 CONFIG_SPI_ATMEL=y
 CONFIG_SPI_GPIO=y
 CONFIG_GPIO_SYSFS=y
+CONFIG_POWER_SUPPLY=y
+CONFIG_POWER_RESET=y
 # CONFIG_HWMON is not set
 CONFIG_SSB=m
 CONFIG_REGULATOR=y
@@ -165,6 +162,7 @@ CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_PWM=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 CONFIG_LEDS_TRIGGER_GPIO=y
@@ -174,6 +172,8 @@ CONFIG_DMADEVICES=y
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_IIO=y
 CONFIG_AT91_ADC=y
+CONFIG_PWM=y
+CONFIG_PWM_ATMEL=y
 CONFIG_EXT4_FS=y
 CONFIG_FANOTIFY=y
 CONFIG_VFAT_FS=y
@@ -188,8 +188,8 @@ CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_DEBUG_FS=y
-# CONFIG_SCHED_DEBUG is not set
 CONFIG_DEBUG_MEMORY_INIT=y
+# CONFIG_SCHED_DEBUG is not set
 # CONFIG_FTRACE is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
-- 
1.9.1

