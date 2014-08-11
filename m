Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbaHKPou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:44:50 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:38519 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088AbaHKPot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:44:49 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: linus.walleij@linaro.org
Cc: shawn.guo@linaro.org, kiran.padwal@smartplayin.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] pinctrl: imx6dl: Make of_device_id array const
Date: Mon, 11 Aug 2014 21:12:06 +0530
Message-Id: <1407771726-19782-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.
---
 drivers/pinctrl/pinctrl-imx6dl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx6dl.c b/drivers/pinctrl/pinctrl-imx6dl.c
index db2a148..656c4b0 100644
--- a/drivers/pinctrl/pinctrl-imx6dl.c
+++ b/drivers/pinctrl/pinctrl-imx6dl.c
@@ -460,7 +460,7 @@ static struct imx_pinctrl_soc_info imx6dl_pinctrl_info = {
 	.npins = ARRAY_SIZE(imx6dl_pinctrl_pads),
 };
 
-static struct of_device_id imx6dl_pinctrl_of_match[] = {
+static const struct of_device_id imx6dl_pinctrl_of_match[] = {
 	{ .compatible = "fsl,imx6dl-iomuxc", },
 	{ /* sentinel */ }
 };
-- 
1.7.9.5

