Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423760Ab3FUTKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 15:10:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58843 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423726Ab3FUTKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 15:10:52 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 2/2] defconfig: msm_defconfig: Enable CONFIG_ARCH_MSM8974
Date: Fri, 21 Jun 2013 12:10:35 -0700
Message-Id: <1371841835-29514-2-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1371841835-29514-1-git-send-email-rvaswani@codeaurora.org>
References: <1371841835-29514-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables MSM8974 build support.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/configs/msm_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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

