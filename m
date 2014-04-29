Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbaD2HHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:07:15 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58881 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbaD2HHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:07:13 -0400
X-Google-Original-From: Lad Prabhakar <prabhakar.csengg@gmail.com
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Olof Johansson <olof@lixom.net>, Tony Prisk <linux@prisktech.co.nz>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2] ARM: configs: drop CONFIG_COMMON_CLK_DEBUG
Date: Tue, 29 Apr 2014 12:37:04 +0530
Message-Id: <1398755224-7530-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch removes COMMON_CLK_DEBUG config option
from defconfig file as this config option is obsolete.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Changes for v2:
 a> Dropped imx defconfig files as suggested by Shawn.
 
 arch/arm/configs/integrator_defconfig   |    1 -
 arch/arm/configs/keystone_defconfig     |    1 -
 arch/arm/configs/sunxi_defconfig        |    1 -
 arch/arm/configs/vt8500_v6_v7_defconfig |    1 -
 4 files changed, 4 deletions(-)

diff --git a/arch/arm/configs/integrator_defconfig b/arch/arm/configs/integrator_defconfig
index 5bae195..c1f5adc 100644
--- a/arch/arm/configs/integrator_defconfig
+++ b/arch/arm/configs/integrator_defconfig
@@ -73,7 +73,6 @@ CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 CONFIG_LEDS_TRIGGER_CPU=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_PL030=y
-CONFIG_COMMON_CLK_DEBUG=y
 CONFIG_EXT2_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
index ec9a41d..f682648 100644
--- a/arch/arm/configs/keystone_defconfig
+++ b/arch/arm/configs/keystone_defconfig
@@ -146,7 +146,6 @@ CONFIG_USB_DWC3_VERBOSE=y
 CONFIG_KEYSTONE_USB_PHY=y
 CONFIG_DMADEVICES=y
 CONFIG_TI_EDMA=y
-CONFIG_COMMON_CLK_DEBUG=y
 CONFIG_MEMORY=y
 CONFIG_TI_AEMIF=y
 CONFIG_EXT4_FS=y
diff --git a/arch/arm/configs/sunxi_defconfig b/arch/arm/configs/sunxi_defconfig
index b5df4a5..28287ae 100644
--- a/arch/arm/configs/sunxi_defconfig
+++ b/arch/arm/configs/sunxi_defconfig
@@ -62,7 +62,6 @@ CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
-CONFIG_COMMON_CLK_DEBUG=y
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
diff --git a/arch/arm/configs/vt8500_v6_v7_defconfig b/arch/arm/configs/vt8500_v6_v7_defconfig
index f052017..9e7a256 100644
--- a/arch/arm/configs/vt8500_v6_v7_defconfig
+++ b/arch/arm/configs/vt8500_v6_v7_defconfig
@@ -73,7 +73,6 @@ CONFIG_LEDS_TRIGGERS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_VT8500=y
 CONFIG_DMADEVICES=y
-CONFIG_COMMON_CLK_DEBUG=y
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_PWM=y
 CONFIG_PWM_VT8500=y
-- 
1.7.9.5

