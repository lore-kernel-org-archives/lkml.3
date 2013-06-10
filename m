Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3FJIUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:20:10 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40488 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3FJIUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:20:08 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Cc: linus.walleij@linaro.org, grant.likely@linaro.org, patches@linaro.org
Subject: [PATCH] gpio_msm: Remove __devinit attribute
Date: Mon, 10 Jun 2013 13:35:41 +0530
Message-Id: <1370851541-23629-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definition of __devinit has been removed from the kernel. Remove
this to fix compilation error.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/gpio/gpio-msm-v1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-msm-v1.c b/drivers/gpio/gpio-msm-v1.c
index c798585a..fb2cc90 100644
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
1.7.9.5

