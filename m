Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab3I1MKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 08:10:00 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34715 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab3I1MJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 08:09:28 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 10/11] pinctrl: imx6sl: Remove redundant of_match_ptr
Date: Sat, 28 Sep 2013 17:38:57 +0530
Message-Id: <1380370138-3513-10-git-send-email-sachin.kamat@linaro.org>
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
 drivers/pinctrl/pinctrl-imx6sl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx6sl.c b/drivers/pinctrl/pinctrl-imx6sl.c
index 4eb7cca..f21b738 100644
--- a/drivers/pinctrl/pinctrl-imx6sl.c
+++ b/drivers/pinctrl/pinctrl-imx6sl.c
@@ -380,7 +380,7 @@ static struct platform_driver imx6sl_pinctrl_driver = {
 	.driver = {
 		.name = "imx6sl-pinctrl",
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(imx6sl_pinctrl_of_match),
+		.of_match_table = imx6sl_pinctrl_of_match,
 	},
 	.probe = imx6sl_pinctrl_probe,
 	.remove = imx_pinctrl_remove,
-- 
1.7.9.5

