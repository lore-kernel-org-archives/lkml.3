Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaHKPiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:38:05 -0400
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:51799 "EHLO
	smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914AbaHKPiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:38:02 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: linus.walleij@linaro.org
Cc: shawn.guo@linaro.org, kiran.padwal@smartplayin.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] pinctrl: imx25: Make of_device_id array const
Date: Mon, 11 Aug 2014 21:04:28 +0530
Message-Id: <1407771277-19477-3-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407771277-19477-1-git-send-email-kiran.padwal@smartplayin.com>
References: <1407771277-19477-1-git-send-email-kiran.padwal@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.
---
 drivers/pinctrl/pinctrl-imx25.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx25.c b/drivers/pinctrl/pinctrl-imx25.c
index 1aae1b6..550e6d7 100644
--- a/drivers/pinctrl/pinctrl-imx25.c
+++ b/drivers/pinctrl/pinctrl-imx25.c
@@ -315,7 +315,7 @@ static struct imx_pinctrl_soc_info imx25_pinctrl_info = {
 	.npins = ARRAY_SIZE(imx25_pinctrl_pads),
 };
 
-static struct of_device_id imx25_pinctrl_of_match[] = {
+static const struct of_device_id imx25_pinctrl_of_match[] = {
 	{ .compatible = "fsl,imx25-iomuxc", },
 	{ /* sentinel */ }
 };
-- 
1.7.9.5

