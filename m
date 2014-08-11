Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaHKLUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:20:51 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62486 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaHKLUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:20:49 -0400
From: Kiran Padwal <kiran.padwal21@gmail.com>
To: swarren@wwwdotorg.org, linus.walleij@linaro.org
Cc: thierry.reding@gmail.com, kiran.padwal21@gmail.com,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: tegra114: Make of_device_id array const
Date: Mon, 11 Aug 2014 16:47:50 +0530
Message-Id: <1407755870-439-1-git-send-email-kiran.padwal21@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.

Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>
---
 drivers/pinctrl/pinctrl-tegra114.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-tegra114.c b/drivers/pinctrl/pinctrl-tegra114.c
index 33614ba..a3db85b 100644
--- a/drivers/pinctrl/pinctrl-tegra114.c
+++ b/drivers/pinctrl/pinctrl-tegra114.c
@@ -1850,7 +1850,7 @@ static int tegra114_pinctrl_probe(struct platform_device *pdev)
 	return tegra_pinctrl_probe(pdev, &tegra114_pinctrl);
 }
 
-static struct of_device_id tegra114_pinctrl_of_match[] = {
+static const struct of_device_id tegra114_pinctrl_of_match[] = {
 	{ .compatible = "nvidia,tegra114-pinmux", },
 	{ },
 };
-- 
1.7.9.5

