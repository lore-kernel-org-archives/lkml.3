Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3I1MJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 08:09:36 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:41735 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3I1MJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 08:09:11 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 02/11] pinctrl: exynos5440: Remove redundant of_match_ptr
Date: Sat, 28 Sep 2013 17:38:49 +0530
Message-Id: <1380370138-3513-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
References: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure of_match_ptr() protects is always compiled in.
Hence of_match_ptr() is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-exynos5440.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-exynos5440.c b/drivers/pinctrl/pinctrl-exynos5440.c
index 544d469..8fe2ab0 100644
--- a/drivers/pinctrl/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/pinctrl-exynos5440.c
@@ -1048,7 +1048,7 @@ static struct platform_driver exynos5440_pinctrl_driver = {
 	.driver = {
 		.name	= "exynos5440-pinctrl",
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(exynos5440_pinctrl_dt_match),
+		.of_match_table = exynos5440_pinctrl_dt_match,
 	},
 };
 
-- 
1.7.9.5

