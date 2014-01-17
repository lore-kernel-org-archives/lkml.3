Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaAQBZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:25:20 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43115 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaAQBZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:25:13 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 2/2] ARM: msm_defconfig: Enable MSM clock drivers
Date: Thu, 16 Jan 2014 17:25:04 -0800
Message-Id: <1389921904-3777-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389921904-3777-1-git-send-email-sboyd@codeaurora.org>
References: <1389921904-3777-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to probe the clock controller devices and boot to a
serial console on all DT enabled MSM platforms.

Cc: David Brown <davidb@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/configs/msm_defconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/configs/msm_defconfig b/arch/arm/configs/msm_defconfig
index 0219c65cefd5..c5858b9eb516 100644
--- a/arch/arm/configs/msm_defconfig
+++ b/arch/arm/configs/msm_defconfig
@@ -114,6 +114,10 @@ CONFIG_USB_GADGET_VBUS_DRAW=500
 CONFIG_NEW_LEDS=y
 CONFIG_RTC_CLASS=y
 CONFIG_STAGING=y
+CONFIG_COMMON_CLK_QCOM=y
+CONFIG_MSM_GCC_8660=y
+CONFIG_MSM_MMCC_8960=y
+CONFIG_MSM_MMCC_8974=y
 CONFIG_MSM_IOMMU=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

