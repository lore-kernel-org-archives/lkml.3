Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab3I1MJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 08:09:53 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47668 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab3I1MJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 08:09:23 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 08/11] pinctrl: samsung: Remove redundant of_match_ptr
Date: Sat, 28 Sep 2013 17:38:55 +0530
Message-Id: <1380370138-3513-8-git-send-email-sachin.kamat@linaro.org>
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
 drivers/pinctrl/pinctrl-samsung.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 92a9d6c..47ec2e8 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -1148,7 +1148,7 @@ static struct platform_driver samsung_pinctrl_driver = {
 	.driver = {
 		.name	= "samsung-pinctrl",
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(samsung_pinctrl_dt_match),
+		.of_match_table = samsung_pinctrl_dt_match,
 	},
 };
 
-- 
1.7.9.5

