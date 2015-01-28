Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbbA2BR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:17:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35673 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbbA2BRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:17:53 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] ARM: qcom: Update defconfig
Date: Wed, 28 Jan 2015 13:38:02 -0800
Message-Id: <1422481082-4821-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.3.0.rc1.33.g42e4583
In-Reply-To: <1422481082-4821-1-git-send-email-sboyd@codeaurora.org>
References: <1422481082-4821-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After removing ARCH_REQUIRE_GPIOLIB we need to select
CONFIG_GPIOLIB to keep building the pinctrl drivers. Make the
defconfig smaller too by running savedefconfig.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/configs/qcom_defconfig | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/configs/qcom_defconfig b/arch/arm/configs/qcom_defconfig
index 881d18b9b4de..2de999338df0 100644
--- a/arch/arm/configs/qcom_defconfig
+++ b/arch/arm/configs/qcom_defconfig
@@ -97,9 +97,9 @@ CONFIG_PINCTRL_APQ8084=y
 CONFIG_PINCTRL_IPQ8064=y
 CONFIG_PINCTRL_MSM8960=y
 CONFIG_PINCTRL_MSM8X74=y
+CONFIG_GPIOLIB=y
 CONFIG_DEBUG_GPIO=y
 CONFIG_GPIO_SYSFS=y
-CONFIG_POWER_SUPPLY=y
 CONFIG_POWER_RESET=y
 CONFIG_POWER_RESET_MSM=y
 CONFIG_THERMAL=y
@@ -134,16 +134,15 @@ CONFIG_RTC_CLASS=y
 CONFIG_DMADEVICES=y
 CONFIG_QCOM_BAM_DMA=y
 CONFIG_STAGING=y
-CONFIG_QCOM_GSBI=y
 CONFIG_COMMON_CLK_QCOM=y
 CONFIG_APQ_MMCC_8084=y
-CONFIG_IPQ_GCC_806X=y
 CONFIG_IPQ_LCC_806X=y
 CONFIG_MSM_GCC_8660=y
 CONFIG_MSM_LCC_8960=y
 CONFIG_MSM_MMCC_8960=y
 CONFIG_MSM_MMCC_8974=y
 CONFIG_MSM_IOMMU=y
+CONFIG_QCOM_GSBI=y
 CONFIG_PHY_QCOM_APQ8064_SATA=y
 CONFIG_PHY_QCOM_IPQ806X_SATA=y
 CONFIG_EXT2_FS=y
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

