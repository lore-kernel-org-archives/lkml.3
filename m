Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbaE2Q0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:26:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48733 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353AbaE2Q0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:26:46 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>, David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH] ARM: qcom: Enable GSBI driver in defconfig
Date: Thu, 29 May 2014 11:26:44 -0500
Message-Id: <1401380804-16108-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 arch/arm/configs/qcom_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/qcom_defconfig b/arch/arm/configs/qcom_defconfig
index bfed753..42ebd72 100644
--- a/arch/arm/configs/qcom_defconfig
+++ b/arch/arm/configs/qcom_defconfig
@@ -131,6 +131,7 @@ CONFIG_RTC_CLASS=y
 CONFIG_DMADEVICES=y
 CONFIG_QCOM_BAM_DMA=y
 CONFIG_STAGING=y
+CONFIG_QCOM_GSBI=y
 CONFIG_COMMON_CLK_QCOM=y
 CONFIG_MSM_GCC_8660=y
 CONFIG_MSM_MMCC_8960=y
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

