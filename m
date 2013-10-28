Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab3J1SDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 14:03:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40717 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab3J1SCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 14:02:11 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 6/6] ARM: msm_defconfig: Enable MSM clock drivers
Date: Mon, 28 Oct 2013 11:02:04 -0700
Message-Id: <1382983324-31155-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.1.600.g3d092bf
In-Reply-To: <1382983324-31155-1-git-send-email-sboyd@codeaurora.org>
References: <1382983324-31155-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/configs/msm_defconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/configs/msm_defconfig b/arch/arm/configs/msm_defconfig
index c5698b7..44c1657 100644
--- a/arch/arm/configs/msm_defconfig
+++ b/arch/arm/configs/msm_defconfig
@@ -117,6 +117,9 @@ CONFIG_USB_GADGET_VBUS_DRAW=500
 CONFIG_NEW_LEDS=y
 CONFIG_RTC_CLASS=y
 CONFIG_STAGING=y
+CONFIG_COMMON_CLK_MSM=y
+CONFIG_MSM_MMCC_8960=y
+CONFIG_MSM_GCC_8974=y
 CONFIG_MSM_IOMMU=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

