Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbaHKO5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:57:46 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:41718 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549AbaHKO5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:57:45 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: linus.walleij@linaro.org
Cc: shawn.guo@linaro.org, kiran.padwal@smartplayin.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] pinctrl: imx6sl: introduce MODULE_DEVICE_TABLE for module autoloading
Date: Mon, 11 Aug 2014 20:24:57 +0530
Message-Id: <1407768897-12086-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable autoloading of pinctrl-imx6sl module when a corresponing DT entry is present.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/pinctrl/pinctrl-imx6sl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-imx6sl.c b/drivers/pinctrl/pinctrl-imx6sl.c
index fa76d6c..e0924bd 100644
--- a/drivers/pinctrl/pinctrl-imx6sl.c
+++ b/drivers/pinctrl/pinctrl-imx6sl.c
@@ -370,6 +370,7 @@ static const struct of_device_id imx6sl_pinctrl_of_match[] = {
 	{ .compatible = "fsl,imx6sl-iomuxc", },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, imx6sl_pinctrl_of_match);
 
 static int imx6sl_pinctrl_probe(struct platform_device *pdev)
 {
-- 
1.7.9.5

