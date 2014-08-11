Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaHKPoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:44:16 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:51679 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753833AbaHKPoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:44:14 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: linus.walleij@linaro.org
Cc: shawn.guo@linaro.org, kiran.padwal@smartplayin.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] pinctrl: imx51: Make of_device_id array const
Date: Mon, 11 Aug 2014 21:11:26 +0530
Message-Id: <1407771686-19708-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.
---
 drivers/pinctrl/pinctrl-imx51.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx51.c b/drivers/pinctrl/pinctrl-imx51.c
index 19ab182..b818051 100644
--- a/drivers/pinctrl/pinctrl-imx51.c
+++ b/drivers/pinctrl/pinctrl-imx51.c
@@ -768,7 +768,7 @@ static struct imx_pinctrl_soc_info imx51_pinctrl_info = {
 	.npins = ARRAY_SIZE(imx51_pinctrl_pads),
 };
 
-static struct of_device_id imx51_pinctrl_of_match[] = {
+static const struct of_device_id imx51_pinctrl_of_match[] = {
 	{ .compatible = "fsl,imx51-iomuxc", },
 	{ /* sentinel */ }
 };
-- 
1.7.9.5

