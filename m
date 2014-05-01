Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaEAG1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:27:52 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:41195 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaEAG1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:27:48 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <b32955@freescale.com>, Marek Vasut <marex@denx.de>,
        <linux-mtd@lists.infradead.org>, Steven Miao <realmz6@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Subject: [PATCH v2 09/12] blackfin: defconfigs: add MTD_SPI_NOR (new dependency for M25P80)
Date: Wed, 30 Apr 2014 23:26:44 -0700
Message-Id: <1398925607-7482-10-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398925607-7482-1-git-send-email-computersforpeace@gmail.com>
References: <1398925607-7482-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These defconfigs contain the CONFIG_M25P80 symbol, which is now
dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to satisfy
the new dependency.

At the same time, drop the now-nonexistent CONFIG_MTD_CHAR symbol.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: adi-buildroot-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
---
 arch/blackfin/configs/BF526-EZBRD_defconfig    | 2 +-
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig | 2 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig    | 2 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig    | 2 +-
 arch/blackfin/configs/BF609-EZKIT_defconfig    | 2 +-
 arch/blackfin/configs/BlackStamp_defconfig     | 3 +--
 arch/blackfin/configs/H8606_defconfig          | 3 +--
 7 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/blackfin/configs/BF526-EZBRD_defconfig b/arch/blackfin/configs/BF526-EZBRD_defconfig
index 2f2c6acf210c..530ba7a6d7b0 100644
--- a/arch/blackfin/configs/BF526-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF526-EZBRD_defconfig
@@ -53,7 +53,6 @@ CONFIG_IP_PNP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_INTELEXT=y
@@ -63,6 +62,7 @@ CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_M25P80=y
 CONFIG_MTD_NAND=m
+CONFIG_MTD_SPI_NOR=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_SCSI=y
 # CONFIG_SCSI_PROC_FS is not set
diff --git a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
index 91535c38e7f2..a21c79275eae 100644
--- a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
@@ -58,7 +58,6 @@ CONFIG_BFIN_SIR0=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_CHAR=m
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_JEDECPROBE=m
 CONFIG_MTD_RAM=y
@@ -66,6 +65,7 @@ CONFIG_MTD_ROM=m
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_M25P80=y
 CONFIG_MTD_NAND=m
+CONFIG_MTD_SPI_NOR=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_SCSI=y
 # CONFIG_SCSI_PROC_FS is not set
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig b/arch/blackfin/configs/BF527-EZKIT_defconfig
index af2738c7441b..5070a860d8c4 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -57,7 +57,6 @@ CONFIG_BFIN_SIR0=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_CHAR=m
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_JEDECPROBE=m
 CONFIG_MTD_RAM=y
@@ -65,6 +64,7 @@ CONFIG_MTD_ROM=m
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_M25P80=y
 CONFIG_MTD_NAND=m
+CONFIG_MTD_SPI_NOR=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_SCSI=y
 # CONFIG_SCSI_PROC_FS is not set
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig b/arch/blackfin/configs/BF548-EZKIT_defconfig
index e716fdfd2cf2..efb293057287 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -64,7 +64,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_FW_LOADER=m
 CONFIG_MTD=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_INTELEXT=y
@@ -75,6 +74,7 @@ CONFIG_MTD_M25P80=y
 CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_BF5XX=y
 # CONFIG_MTD_NAND_BF5XX_HWECC is not set
+CONFIG_MTD_SPI_NOR=y
 CONFIG_BLK_DEV_RAM=y
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/blackfin/configs/BF609-EZKIT_defconfig b/arch/blackfin/configs/BF609-EZKIT_defconfig
index 4ca39ab6b2bf..a7e9bfd84183 100644
--- a/arch/blackfin/configs/BF609-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF609-EZKIT_defconfig
@@ -57,7 +57,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_FW_LOADER=m
 CONFIG_MTD=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_INTELEXT=y
@@ -65,6 +64,7 @@ CONFIG_MTD_CFI_STAA=y
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_M25P80=y
+CONFIG_MTD_SPI_NOR=y
 CONFIG_MTD_UBI=m
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
diff --git a/arch/blackfin/configs/BlackStamp_defconfig b/arch/blackfin/configs/BlackStamp_defconfig
index 3853c473b443..f4a9200e1ab1 100644
--- a/arch/blackfin/configs/BlackStamp_defconfig
+++ b/arch/blackfin/configs/BlackStamp_defconfig
@@ -45,7 +45,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=m
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=m
 CONFIG_MTD_CFI_AMDSTD=m
@@ -53,7 +52,7 @@ CONFIG_MTD_RAM=y
 CONFIG_MTD_ROM=m
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_M25P80=y
-# CONFIG_M25PXX_USE_FAST_READ is not set
+CONFIG_MTD_SPI_NOR=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_NBD=y
 CONFIG_BLK_DEV_RAM=y
diff --git a/arch/blackfin/configs/H8606_defconfig b/arch/blackfin/configs/H8606_defconfig
index f754e490bbfd..0ff97d8d047a 100644
--- a/arch/blackfin/configs/H8606_defconfig
+++ b/arch/blackfin/configs/H8606_defconfig
@@ -36,13 +36,12 @@ CONFIG_IRTTY_SIR=m
 # CONFIG_WIRELESS is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
 CONFIG_MTD_ROM=y
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_M25P80=y
-# CONFIG_M25PXX_USE_FAST_READ is not set
+CONFIG_MTD_SPI_NOR=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_MISC_DEVICES=y
 CONFIG_EEPROM_AT25=y
-- 
1.8.3.2

