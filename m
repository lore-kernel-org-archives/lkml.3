Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaHKPki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:40:38 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:54916 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753692AbaHKPkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:40:37 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: linus.walleij@linaro.org
Cc: shawn.guo@linaro.org, kiran.padwal@smartplayin.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] pinctrl: imx27: Make of_device_id array const
Date: Mon, 11 Aug 2014 21:07:55 +0530
Message-Id: <1407771475-19543-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.
---
 drivers/pinctrl/pinctrl-imx27.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx27.c b/drivers/pinctrl/pinctrl-imx27.c
index f8dfefb..945ecca 100644
--- a/drivers/pinctrl/pinctrl-imx27.c
+++ b/drivers/pinctrl/pinctrl-imx27.c
@@ -389,7 +389,7 @@ static struct imx1_pinctrl_soc_info imx27_pinctrl_info = {
 	.npins = ARRAY_SIZE(imx27_pinctrl_pads),
 };
 
-static struct of_device_id imx27_pinctrl_of_match[] = {
+static const struct of_device_id imx27_pinctrl_of_match[] = {
 	{ .compatible = "fsl,imx27-iomuxc", },
 	{ /* sentinel */ }
 };
-- 
1.7.9.5

