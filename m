Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaHKPpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:45:09 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:49653 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754256AbaHKPpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:45:07 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: linus.walleij@linaro.org
Cc: shawn.guo@linaro.org, kiran.padwal@smartplayin.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] pinctrl: imx6q: Make of_device_id array const
Date: Mon, 11 Aug 2014 21:12:26 +0530
Message-Id: <1407771746-19819-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.
---
 drivers/pinctrl/pinctrl-imx6q.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx6q.c b/drivers/pinctrl/pinctrl-imx6q.c
index 8eb5ac1..59bb5b4 100644
--- a/drivers/pinctrl/pinctrl-imx6q.c
+++ b/drivers/pinctrl/pinctrl-imx6q.c
@@ -466,7 +466,7 @@ static struct imx_pinctrl_soc_info imx6q_pinctrl_info = {
 	.npins = ARRAY_SIZE(imx6q_pinctrl_pads),
 };
 
-static struct of_device_id imx6q_pinctrl_of_match[] = {
+static const struct of_device_id imx6q_pinctrl_of_match[] = {
 	{ .compatible = "fsl,imx6q-iomuxc", },
 	{ /* sentinel */ }
 };
-- 
1.7.9.5

