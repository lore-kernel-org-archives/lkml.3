Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3BQN67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 08:58:59 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:37742 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab3BQN66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 08:58:58 -0500
Message-ID: <1361109527.4302.1.camel@phoenix>
Subject: [PATCH] pinctrl: abx500: Add terminating entry for of_device_id
 table
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Date: Sun, 17 Feb 2013 21:58:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-abx500.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index caecdd3..685808a 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -834,6 +834,7 @@ static const struct of_device_id abx500_gpio_match[] = {
 	{ .compatible = "stericsson,ab8505-gpio", .data = (void *)PINCTRL_AB8505, },
 	{ .compatible = "stericsson,ab8540-gpio", .data = (void *)PINCTRL_AB8540, },
 	{ .compatible = "stericsson,ab9540-gpio", .data = (void *)PINCTRL_AB9540, },
+	{ }
 };
 
 static int abx500_gpio_probe(struct platform_device *pdev)
-- 
1.7.9.5



