Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbaBKUWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:22:11 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48367 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbaBKUWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:22:08 -0500
From: Kumar Gala <galak@codeaurora.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] power: reset: msm - switch Kconfig to ARCH_QCOM depends
Date: Tue, 11 Feb 2014 14:22:06 -0600
Message-Id: <1392150126-21744-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've split Qualcomm MSM support into legacy and multiplatform.  The reset
driver is only relevant on the multiplatform supported SoCs so switch the
Kconfig depends to ARCH_QCOM.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
Dmitry, David,

If you can ack this I'll send it via linux-qcom/arm-soc tree's

thanks

- k

 drivers/power/reset/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 6d452a7..fa0e4e0 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -22,7 +22,7 @@ config POWER_RESET_GPIO
 
 config POWER_RESET_MSM
 	bool "Qualcomm MSM power-off driver"
-	depends on POWER_RESET && ARCH_MSM
+	depends on POWER_RESET && ARCH_QCOM
 	help
 	  Power off and restart support for Qualcomm boards.
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

