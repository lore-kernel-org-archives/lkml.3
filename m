Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaFWLld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:41:33 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:59031 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaFWLlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:41:32 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: syin@broadcom.com, linus.walleij@linaro.org, spk.linux@gmail.com
Subject: [PATCH 1/1] pinctrl: bcm281xx: Staticize bcm281xx_pinctrl_probe
Date: Mon, 23 Jun 2014 17:08:18 +0530
Message-Id: <1403523498-3035-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm281xx_pinctrl_probe is local to this file. Make it static.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/pinctrl/pinctrl-bcm281xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-bcm281xx.c b/drivers/pinctrl/pinctrl-bcm281xx.c
index 3bed792b2c03..c5ca9e633fff 100644
--- a/drivers/pinctrl/pinctrl-bcm281xx.c
+++ b/drivers/pinctrl/pinctrl-bcm281xx.c
@@ -1396,7 +1396,7 @@ static struct pinctrl_desc bcm281xx_pinctrl_desc = {
 	.owner = THIS_MODULE,
 };
 
-int __init bcm281xx_pinctrl_probe(struct platform_device *pdev)
+static int __init bcm281xx_pinctrl_probe(struct platform_device *pdev)
 {
 	struct bcm281xx_pinctrl_data *pdata = &bcm281xx_pinctrl;
 	struct resource *res;
-- 
1.7.9.5

