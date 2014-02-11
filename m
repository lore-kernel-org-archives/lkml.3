Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbaBKUWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:22:21 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48379 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290AbaBKUWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:22:15 -0500
From: Kumar Gala <galak@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Kumar Gala <galak@codeaurora.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] gpio: msm: switch Kconfig to ARCH_QCOM depends
Date: Tue, 11 Feb 2014 14:22:12 -0600
Message-Id: <1392150132-21877-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've split Qualcomm MSM support into legacy and multiplatform.  The gpio
msm-v2 driver is only relevant on the multiplatform supported SoCs so
switch the Kconfig depends to ARCH_QCOM.

CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
Linus,

If you can ack this I'll send it via linux-qcom/arm-soc tree's

thanks

- k

 drivers/gpio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 6973387..aa74949 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -192,7 +192,7 @@ config GPIO_MSM_V1
 
 config GPIO_MSM_V2
 	tristate "Qualcomm MSM GPIO v2"
-	depends on GPIOLIB && OF && ARCH_MSM
+	depends on GPIOLIB && OF && ARCH_QCOM
 	help
 	  Say yes here to support the GPIO interface on ARM v7 based
 	  Qualcomm MSM chips.  Most of the pins on the MSM can be
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

