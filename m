Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaHKOFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:05:10 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41621 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaHKOFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:05:09 -0400
From: Kiran Padwal <kiran.padwal21@gmail.com>
To: swarren@wwwdotorg.org, linus.walleij@linaro.org
Cc: thierry.reding@gmail.com, kiran.padwal21@gmail.com,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] pinctrl: tegra124: Make of_device_id array const
Date: Mon, 11 Aug 2014 19:32:21 +0530
Message-Id: <1407765741-3846-1-git-send-email-kiran.padwal21@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.

Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>
---
 drivers/pinctrl/pinctrl-tegra124.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-tegra124.c b/drivers/pinctrl/pinctrl-tegra124.c
index e80797e..cb3e596 100644
--- a/drivers/pinctrl/pinctrl-tegra124.c
+++ b/drivers/pinctrl/pinctrl-tegra124.c
@@ -1996,7 +1996,7 @@ static int tegra124_pinctrl_probe(struct platform_device *pdev)
 	return tegra_pinctrl_probe(pdev, &tegra124_pinctrl);
 }
 
-static struct of_device_id tegra124_pinctrl_of_match[] = {
+static const struct of_device_id tegra124_pinctrl_of_match[] = {
 	{ .compatible = "nvidia,tegra124-pinmux", },
 	{ },
 };
-- 
1.7.9.5

