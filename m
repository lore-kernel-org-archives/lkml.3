Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaHKOzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:55:48 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:33859 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753933AbaHKOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:55:47 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: linus.walleij@linaro.org
Cc: shawn.guo@linaro.org, kiran.padwal@smartplayin.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] pinctrl: imx6sl: Make of_device_id array const
Date: Mon, 11 Aug 2014 20:22:48 +0530
Message-Id: <1407768768-12033-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/pinctrl/pinctrl-imx6sl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx6sl.c b/drivers/pinctrl/pinctrl-imx6sl.c
index f21b738..fa76d6c 100644
--- a/drivers/pinctrl/pinctrl-imx6sl.c
+++ b/drivers/pinctrl/pinctrl-imx6sl.c
@@ -366,7 +366,7 @@ static struct imx_pinctrl_soc_info imx6sl_pinctrl_info = {
 	.npins = ARRAY_SIZE(imx6sl_pinctrl_pads),
 };
 
-static struct of_device_id imx6sl_pinctrl_of_match[] = {
+static const struct of_device_id imx6sl_pinctrl_of_match[] = {
 	{ .compatible = "fsl,imx6sl-iomuxc", },
 	{ /* sentinel */ }
 };
-- 
1.7.9.5

