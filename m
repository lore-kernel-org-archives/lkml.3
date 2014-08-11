Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbaHKPm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:42:57 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:50228 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754170AbaHKPk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:40:57 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: linus.walleij@linaro.org
Cc: shawn.guo@linaro.org, kiran.padwal@smartplayin.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] pinctrl: imx28: Make of_device_id array const
Date: Mon, 11 Aug 2014 21:08:13 +0530
Message-Id: <1407771493-19581-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.
---
 drivers/pinctrl/pinctrl-imx28.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx28.c b/drivers/pinctrl/pinctrl-imx28.c
index 79c9c8d..3bd45da 100644
--- a/drivers/pinctrl/pinctrl-imx28.c
+++ b/drivers/pinctrl/pinctrl-imx28.c
@@ -388,7 +388,7 @@ static int imx28_pinctrl_probe(struct platform_device *pdev)
 	return mxs_pinctrl_probe(pdev, &imx28_pinctrl_data);
 }
 
-static struct of_device_id imx28_pinctrl_of_match[] = {
+static const struct of_device_id imx28_pinctrl_of_match[] = {
 	{ .compatible = "fsl,imx28-pinctrl", },
 	{ /* sentinel */ }
 };
-- 
1.7.9.5

