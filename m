Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaIBIv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:51:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36146 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752341AbaIBIuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:50:20 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 3/7] ARM: at91: at91sam9261_9g10: update defconfig
Date: Tue,  2 Sep 2014 10:49:59 +0200
Message-Id: <1409647803-8054-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409647803-8054-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1409647803-8054-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update defconfig, adding power/reset and removing deprecated config options.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/configs/at91sam9261_9g10_defconfig | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/configs/at91sam9261_9g10_defconfig b/arch/arm/configs/at91sam9261_9g10_defconfig
index f80e993b04ce..0c505d801e25 100644
--- a/arch/arm/configs/at91sam9261_9g10_defconfig
+++ b/arch/arm/configs/at91sam9261_9g10_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_KERNEL_LZMA=y
 # CONFIG_SWAP is not set
@@ -20,7 +19,6 @@ CONFIG_MACH_AT91SAM9261EK=y
 CONFIG_MACH_AT91SAM9G10EK=y
 # CONFIG_ARM_THUMB is not set
 CONFIG_AEABI=y
-# CONFIG_OABI_COMPAT is not set
 CONFIG_ZBOOT_ROM_TEXT=0x0
 CONFIG_ZBOOT_ROM_BSS=0x0
 CONFIG_CMDLINE="mem=64M console=ttyS0,115200 initrd=0x21100000,3145728 root=/dev/ram0 rw"
@@ -55,7 +53,6 @@ CONFIG_ATMEL_TCLIB=y
 CONFIG_ATMEL_SSC=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
-CONFIG_SCSI_MULTI_LUN=y
 CONFIG_NETDEVICES=y
 CONFIG_DM9000=y
 CONFIG_USB_ZD1201=m
@@ -87,6 +84,8 @@ CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_GPIO=y
 CONFIG_SPI=y
 CONFIG_SPI_ATMEL=y
+CONFIG_POWER_SUPPLY=y
+CONFIG_POWER_RESET=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_WATCHDOG_NOWAYOUT=y
-- 
1.9.1

