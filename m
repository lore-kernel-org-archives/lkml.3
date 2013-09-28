Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab3I1MJo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 08:09:44 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:43860 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab3I1MJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 08:09:16 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 05/11] pinctrl: imx53: Remove redundant of_match_ptr
Date: Sat, 28 Sep 2013 17:38:52 +0530
Message-Id: <1380370138-3513-5-git-send-email-sachin.kamat@linaro.org>
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
 drivers/pinctrl/pinctrl-imx53.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx53.c b/drivers/pinctrl/pinctrl-imx53.c
index 17562ae..f8d45c4 100644
--- a/drivers/pinctrl/pinctrl-imx53.c
+++ b/drivers/pinctrl/pinctrl-imx53.c
@@ -468,7 +468,7 @@ static struct platform_driver imx53_pinctrl_driver = {
 	.driver = {
 		.name = "imx53-pinctrl",
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(imx53_pinctrl_of_match),
+		.of_match_table = imx53_pinctrl_of_match,
 	},
 	.probe = imx53_pinctrl_probe,
 	.remove = imx_pinctrl_remove,
-- 
1.7.9.5

