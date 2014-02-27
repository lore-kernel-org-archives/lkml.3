Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaB0Uy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:54:29 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45610 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaB0Uy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:54:28 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH v1.1/3] ARM: config: Add qcom_defconfig
Date: Thu, 27 Feb 2014 12:54:24 -0800
Message-Id: <1393534464-14620-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <530F985E.5030503@codeaurora.org>
References: <530F985E.5030503@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a defconfig for mach-qcom platforms (copied from msm_defconfig).
Although these platforms are part of the multi-platform kernel, it's
useful to have a stripped down version of the defconfig that just
selects the DT based Qualcomm platforms and drivers.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Changes since v1:
 * Added CONFIG_DEVTMPFS/DEVTMPFS_MOUNT per Josh

 arch/arm/configs/{msm_defconfig => qcom_defconfig} | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)
 copy arch/arm/configs/{msm_defconfig => qcom_defconfig} (97%)

diff --git a/arch/arm/configs/msm_defconfig b/arch/arm/configs/qcom_defconfig
similarity index 97%
copy from arch/arm/configs/msm_defconfig
copy to arch/arm/configs/qcom_defconfig
index c5858b9eb516..5f11d6de9084 100644
--- a/arch/arm/configs/msm_defconfig
+++ b/arch/arm/configs/qcom_defconfig
@@ -17,7 +17,7 @@ CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
 CONFIG_MODVERSIONS=y
 CONFIG_PARTITION_ADVANCED=y
-CONFIG_ARCH_MSM_DT=y
+CONFIG_ARCH_QCOM=y
 CONFIG_ARCH_MSM8X60=y
 CONFIG_ARCH_MSM8960=y
 CONFIG_ARCH_MSM8974=y
@@ -27,7 +27,6 @@ CONFIG_AEABI=y
 CONFIG_HIGHMEM=y
 CONFIG_HIGHPTE=y
 CONFIG_CLEANCACHE=y
-CONFIG_CC_STACKPROTECTOR=y
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
 CONFIG_VFP=y
@@ -49,6 +48,8 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_CFG80211=y
 CONFIG_RFKILL=y
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_SCSI=y
@@ -111,7 +112,6 @@ CONFIG_USB_SERIAL=y
 CONFIG_USB_GADGET=y
 CONFIG_USB_GADGET_DEBUG_FILES=y
 CONFIG_USB_GADGET_VBUS_DRAW=500
-CONFIG_NEW_LEDS=y
 CONFIG_RTC_CLASS=y
 CONFIG_STAGING=y
 CONFIG_COMMON_CLK_QCOM=y
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

