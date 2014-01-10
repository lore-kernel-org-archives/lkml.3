Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaAJTMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:12:14 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52448 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaAJTML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:12:11 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH] ARM: msm_defconfig: Update for multi-platform
Date: Fri, 10 Jan 2014 11:12:08 -0800
Message-Id: <1389381128-28280-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_MSM is a hidden config option now so this defconfig needs to
be updated to select ARCH_MSM_DT instead. While we're here,
remove dead symbols (SSBI), drop selected symbols (ZRELADDR,
PHYLIB, USB_PHY) and enable the MSM random driver (HW_RANDOM_MSM).

Cc: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/configs/msm_defconfig | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm/configs/msm_defconfig b/arch/arm/configs/msm_defconfig
index c5698b7ce444..0219c65cefd5 100644
--- a/arch/arm/configs/msm_defconfig
+++ b/arch/arm/configs/msm_defconfig
@@ -17,7 +17,7 @@ CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
 CONFIG_MODVERSIONS=y
 CONFIG_PARTITION_ADVANCED=y
-CONFIG_ARCH_MSM=y
+CONFIG_ARCH_MSM_DT=y
 CONFIG_ARCH_MSM8X60=y
 CONFIG_ARCH_MSM8960=y
 CONFIG_ARCH_MSM8974=y
@@ -30,7 +30,6 @@ CONFIG_CLEANCACHE=y
 CONFIG_CC_STACKPROTECTOR=y
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
-CONFIG_AUTO_ZRELADDR=y
 CONFIG_VFP=y
 CONFIG_NEON=y
 # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
@@ -63,7 +62,6 @@ CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_SCAN_ASYNC=y
 CONFIG_NETDEVICES=y
 CONFIG_DUMMY=y
-CONFIG_PHYLIB=y
 CONFIG_SLIP=y
 CONFIG_SLIP_COMPRESSED=y
 CONFIG_SLIP_MODE_SLIP6=y
@@ -82,10 +80,10 @@ CONFIG_SERIO_LIBPS2=y
 CONFIG_SERIAL_MSM=y
 CONFIG_SERIAL_MSM_CONSOLE=y
 CONFIG_HW_RANDOM=y
+CONFIG_HW_RANDOM_MSM=y
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_SPI=y
-CONFIG_SSBI=y
 CONFIG_DEBUG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_POWER_SUPPLY=y
@@ -104,7 +102,6 @@ CONFIG_SND_DYNAMIC_MINORS=y
 CONFIG_SND_SOC=y
 CONFIG_HID_BATTERY_STRENGTH=y
 CONFIG_USB=y
-CONFIG_USB_PHY=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 CONFIG_USB_MON=y
 CONFIG_USB_EHCI_HCD=y
@@ -131,10 +128,10 @@ CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_CIFS=y
 CONFIG_PRINTK_TIME=y
+CONFIG_DYNAMIC_DEBUG=y
+CONFIG_DEBUG_INFO=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_LOCKUP_DETECTOR=y
 # CONFIG_DETECT_HUNG_TASK is not set
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_TIMER_STATS=y
-CONFIG_DEBUG_INFO=y
-CONFIG_DYNAMIC_DEBUG=y
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

