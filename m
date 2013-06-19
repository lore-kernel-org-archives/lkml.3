Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab3FSBDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:03:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38267 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933937Ab3FSBCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:02:42 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] drivers: gpio: msm: Remove __devinit
Date: Tue, 18 Jun 2013 18:02:27 -0700
Message-Id: <1371603747-27436-5-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1371603747-27436-1-git-send-email-rvaswani@codeaurora.org>
References: <1371603747-27436-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove stray usage of __devinit as it has been removed.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 drivers/gpio/gpio-msm-v1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-msm-v1.c b/drivers/gpio/gpio-msm-v1.c
index c798585..fb2cc90 100644
--- a/drivers/gpio/gpio-msm-v1.c
+++ b/drivers/gpio/gpio-msm-v1.c
@@ -630,7 +630,7 @@ static struct irq_chip msm_gpio_irq_chip = {
 	.irq_set_type  = msm_gpio_irq_set_type,
 };
 
-static int __devinit gpio_msm_v1_probe(struct platform_device *pdev)
+static int gpio_msm_v1_probe(struct platform_device *pdev)
 {
 	int i, j = 0;
 	const struct platform_device_id *dev_id = platform_get_device_id(pdev);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

