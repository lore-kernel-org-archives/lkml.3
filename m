Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3G3PC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:02:27 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:42286 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753981Ab3G3PAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:00:04 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 04/10] pinctrl: sunxi: Wrap long compatible declaration lines
Date: Tue, 30 Jul 2013 16:59:48 +0200
Message-Id: <1375196394-21138-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375196394-21138-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375196394-21138-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compatible declaration and their associated data are exceeding the
80-characters width limit.

Split these lines to make them more readable and fit in the kernel
coding guidelines.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-sunxi.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 5985e60..246310b 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -628,10 +628,22 @@ static void sunxi_pinctrl_irq_handler(unsigned irq, struct irq_desc *desc)
 }
 
 static struct of_device_id sunxi_pinctrl_match[] = {
-	{ .compatible = "allwinner,sun4i-a10-pinctrl", .data = (void *)&sun4i_a10_pinctrl_data },
-	{ .compatible = "allwinner,sun5i-a10s-pinctrl", .data = (void *)&sun5i_a10s_pinctrl_data },
-	{ .compatible = "allwinner,sun5i-a13-pinctrl", .data = (void *)&sun5i_a13_pinctrl_data },
-	{ .compatible = "allwinner,sun6i-a31-pinctrl", .data = (void *)&sun6i_a31_pinctrl_data },
+	{
+		.compatible = "allwinner,sun4i-a10-pinctrl",
+		.data = (void *)&sun4i_a10_pinctrl_data,
+	},
+	{
+		.compatible = "allwinner,sun5i-a10s-pinctrl",
+		.data = (void *)&sun5i_a10s_pinctrl_data,
+	},
+	{
+		.compatible = "allwinner,sun5i-a13-pinctrl",
+		.data = (void *)&sun5i_a13_pinctrl_data,
+	},
+	{
+		.compatible = "allwinner,sun6i-a31-pinctrl",
+		.data = (void *)&sun6i_a31_pinctrl_data,
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(of, sunxi_pinctrl_match);
-- 
1.8.3.4

