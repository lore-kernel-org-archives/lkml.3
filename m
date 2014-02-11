Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaBKTqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:46:40 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39375 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754361AbaBKToZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:44:25 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/3] arm: at91sam9260_9g20: remove useless configuration
Date: Tue, 11 Feb 2014 20:44:00 +0100
Message-Id: <1392147841-7815-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392147841-7815-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1392147841-7815-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few configuration symbols are deprecated and disappeared a few versions ago,
remove them.

CONFIG_FPE_NWFPE depends on OABI_COMPAT which was not selected.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/configs/at91sam9260_9g20_defconfig | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm/configs/at91sam9260_9g20_defconfig b/arch/arm/configs/at91sam9260_9g20_defconfig
index 69b6928d3d9d..2c879bc29f86 100644
--- a/arch/arm/configs/at91sam9260_9g20_defconfig
+++ b/arch/arm/configs/at91sam9260_9g20_defconfig
@@ -32,15 +32,12 @@ CONFIG_AT91_PROGRAMMABLE_CLOCKS=y
 CONFIG_AT91_SLOW_CLOCK=y
 # CONFIG_ARM_THUMB is not set
 CONFIG_AEABI=y
-CONFIG_LEDS=y
-CONFIG_LEDS_CPU=y
 CONFIG_ZBOOT_ROM_TEXT=0x0
 CONFIG_ZBOOT_ROM_BSS=0x0
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
 CONFIG_CMDLINE="mem=64M console=ttyS0,115200 initrd=0x21100000,3145728 root=/dev/ram0 rw"
 CONFIG_AUTO_ZRELADDR=y
-CONFIG_FPE_NWFPE=y
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
@@ -59,7 +56,6 @@ CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_MTD=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_DATAFLASH=y
 CONFIG_MTD_NAND=y
@@ -67,7 +63,6 @@ CONFIG_MTD_NAND_ATMEL=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
-CONFIG_MISC_DEVICES=y
 CONFIG_EEPROM_AT25=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
@@ -114,8 +109,6 @@ CONFIG_SND_PCM_OSS=y
 CONFIG_SND_SEQUENCER_OSS=y
 # CONFIG_SND_VERBOSE_PROCFS is not set
 CONFIG_USB=y
-CONFIG_USB_DEVICEFS=y
-# CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_MON=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_STORAGE=y
-- 
1.8.3.2

