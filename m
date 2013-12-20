Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab3LTTKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:22 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37429 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3LTTJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:35 -0500
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 3/7] defconfig: msm_defconfig: Enable CONFIG_ARCH_MSM8974
Date: Fri, 20 Dec 2013 11:09:16 -0800
Message-Id: <1387566560-23948-4-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1387566560-23948-1-git-send-email-davidb@codeaurora.org>
References: <1387566560-23948-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

This patch enables MSM8974 build support.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/configs/msm_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/msm_defconfig b/arch/arm/configs/msm_defconfig
index 690b5f9..0ed32e5 100644
--- a/arch/arm/configs/msm_defconfig
+++ b/arch/arm/configs/msm_defconfig
@@ -20,6 +20,7 @@ CONFIG_PARTITION_ADVANCED=y
 CONFIG_ARCH_MSM=y
 CONFIG_ARCH_MSM8X60=y
 CONFIG_ARCH_MSM8960=y
+CONFIG_ARCH_MSM8974=y
 CONFIG_SMP=y
 CONFIG_PREEMPT=y
 CONFIG_AEABI=y
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

