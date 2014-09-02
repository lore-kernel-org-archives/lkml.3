Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaIBIuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:50:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36149 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752875AbaIBIuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:50:21 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 4/7] ARM: at91: at91sam9263: update defconfig
Date: Tue,  2 Sep 2014 10:50:00 +0200
Message-Id: <1409647803-8054-5-git-send-email-alexandre.belloni@free-electrons.com>
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
 arch/arm/configs/at91sam9263_defconfig | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm/configs/at91sam9263_defconfig b/arch/arm/configs/at91sam9263_defconfig
index e40026364e57..8b671c977b81 100644
--- a/arch/arm/configs/at91sam9263_defconfig
+++ b/arch/arm/configs/at91sam9263_defconfig
@@ -18,7 +18,6 @@ CONFIG_MACH_AT91SAM9263EK=y
 CONFIG_MTD_AT91_DATAFLASH_CARD=y
 # CONFIG_ARM_THUMB is not set
 CONFIG_AEABI=y
-# CONFIG_OABI_COMPAT is not set
 CONFIG_ZBOOT_ROM_TEXT=0x0
 CONFIG_ZBOOT_ROM_BSS=0x0
 CONFIG_CMDLINE="mem=64M console=ttyS0,115200 initrd=0x21100000,3145728 root=/dev/ram0 rw"
@@ -51,7 +50,6 @@ CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_MTD=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_NFTL=y
 CONFIG_NFTL_RW=y
@@ -64,13 +62,10 @@ CONFIG_MTD_UBI_GLUEBI=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
-CONFIG_ATMEL_PWM=y
 CONFIG_ATMEL_TCLIB=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
-CONFIG_SCSI_MULTI_LUN=y
 CONFIG_NETDEVICES=y
-CONFIG_MII=y
 CONFIG_MACB=y
 CONFIG_SMSC_PHY=y
 # CONFIG_WLAN is not set
@@ -92,6 +87,8 @@ CONFIG_I2C_GPIO=y
 CONFIG_SPI=y
 CONFIG_SPI_ATMEL=y
 CONFIG_GPIO_SYSFS=y
+CONFIG_POWER_SUPPLY=y
+CONFIG_POWER_RESET=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_WATCHDOG_NOWAYOUT=y
@@ -103,7 +100,6 @@ CONFIG_LCD_CLASS_DEVICE=y
 CONFIG_BACKLIGHT_CLASS_DEVICE=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
-CONFIG_FONTS=y
 CONFIG_LOGO=y
 CONFIG_SOUND=y
 CONFIG_SND=y
@@ -129,12 +125,14 @@ CONFIG_SDIO_UART=m
 CONFIG_MMC_ATMELMCI=m
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
-CONFIG_LEDS_ATMEL_PWM=y
 CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_PWM=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_AT91SAM9=y
+CONFIG_PWM=y
+CONFIG_PWM_ATMEL=y
 CONFIG_EXT4_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
@@ -150,3 +148,4 @@ CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
 CONFIG_DEBUG_USER=y
 CONFIG_XZ_DEC=y
+CONFIG_FONTS=y
-- 
1.9.1

