Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaB0CRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:17:09 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33520 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbaB0CQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:16:51 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] ARM: config: Update msm_defconfig
Date: Wed, 26 Feb 2014 18:16:34 -0800
Message-Id: <1393467394-10907-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1393467394-10907-1-git-send-email-sboyd@codeaurora.org>
References: <1393467394-10907-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that DT based platforms are split out of mach-msm into
mach-qcom, put back a non-DT based SoC into the msm_defconfig and
stop selecting unsupported drivers.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/configs/msm_defconfig | 25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/arch/arm/configs/msm_defconfig b/arch/arm/configs/msm_defconfig
index c5858b9eb516..7f52dad97f51 100644
--- a/arch/arm/configs/msm_defconfig
+++ b/arch/arm/configs/msm_defconfig
@@ -17,21 +17,14 @@ CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
 CONFIG_MODVERSIONS=y
 CONFIG_PARTITION_ADVANCED=y
-CONFIG_ARCH_MSM_DT=y
-CONFIG_ARCH_MSM8X60=y
-CONFIG_ARCH_MSM8960=y
-CONFIG_ARCH_MSM8974=y
-CONFIG_SMP=y
+CONFIG_ARCH_MSM=y
 CONFIG_PREEMPT=y
 CONFIG_AEABI=y
 CONFIG_HIGHMEM=y
 CONFIG_HIGHPTE=y
 CONFIG_CLEANCACHE=y
-CONFIG_CC_STACKPROTECTOR=y
-CONFIG_ARM_APPENDED_DTB=y
-CONFIG_ARM_ATAG_DTB_COMPAT=y
+CONFIG_AUTO_ZRELADDR=y
 CONFIG_VFP=y
-CONFIG_NEON=y
 # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
 CONFIG_NET=y
 CONFIG_PACKET=y
@@ -79,16 +72,12 @@ CONFIG_SERIO_LIBPS2=y
 # CONFIG_LEGACY_PTYS is not set
 CONFIG_SERIAL_MSM=y
 CONFIG_SERIAL_MSM_CONSOLE=y
-CONFIG_HW_RANDOM=y
-CONFIG_HW_RANDOM_MSM=y
+# CONFIG_HW_RANDOM is not set
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_SPI=y
 CONFIG_DEBUG_GPIO=y
 CONFIG_GPIO_SYSFS=y
-CONFIG_POWER_SUPPLY=y
-CONFIG_POWER_RESET=y
-CONFIG_POWER_RESET_MSM=y
 CONFIG_THERMAL=y
 CONFIG_REGULATOR=y
 CONFIG_MEDIA_SUPPORT=y
@@ -100,25 +89,17 @@ CONFIG_SND_DYNAMIC_MINORS=y
 # CONFIG_SND_SPI is not set
 # CONFIG_SND_USB is not set
 CONFIG_SND_SOC=y
-CONFIG_HID_BATTERY_STRENGTH=y
 CONFIG_USB=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 CONFIG_USB_MON=y
 CONFIG_USB_EHCI_HCD=y
-CONFIG_USB_EHCI_MSM=y
 CONFIG_USB_ACM=y
 CONFIG_USB_SERIAL=y
 CONFIG_USB_GADGET=y
 CONFIG_USB_GADGET_DEBUG_FILES=y
 CONFIG_USB_GADGET_VBUS_DRAW=500
-CONFIG_NEW_LEDS=y
 CONFIG_RTC_CLASS=y
 CONFIG_STAGING=y
-CONFIG_COMMON_CLK_QCOM=y
-CONFIG_MSM_GCC_8660=y
-CONFIG_MSM_MMCC_8960=y
-CONFIG_MSM_MMCC_8974=y
-CONFIG_MSM_IOMMU=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT3_FS=y
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

