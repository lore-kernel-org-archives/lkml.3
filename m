Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3I1MKF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 08:10:05 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36410 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab3I1MJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 08:09:30 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 11/11] pinctrl: plgpio: Remove redundant of_match_ptr
Date: Sat, 28 Sep 2013 17:38:58 +0530
Message-Id: <1380370138-3513-11-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
References: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure of_match_ptr() protects is always compiled in.
Hence of_match_ptr() is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/pinctrl/spear/pinctrl-plgpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
index 0a7f0bdb..ff2940e 100644
--- a/drivers/pinctrl/spear/pinctrl-plgpio.c
+++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
@@ -735,7 +735,7 @@ static struct platform_driver plgpio_driver = {
 		.owner = THIS_MODULE,
 		.name = "spear-plgpio",
 		.pm = &plgpio_dev_pm_ops,
-		.of_match_table = of_match_ptr(plgpio_of_match),
+		.of_match_table = plgpio_of_match,
 	},
 };
 
-- 
1.7.9.5

