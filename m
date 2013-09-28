Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3I1MJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 08:09:39 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52316 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab3I1MJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 08:09:11 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 03/11] pinctrl: imx35: Remove redundant of_match_ptr
Date: Sat, 28 Sep 2013 17:38:50 +0530
Message-Id: <1380370138-3513-3-git-send-email-sachin.kamat@linaro.org>
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
 drivers/pinctrl/pinctrl-imx35.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx35.c b/drivers/pinctrl/pinctrl-imx35.c
index c454982..278a04a 100644
--- a/drivers/pinctrl/pinctrl-imx35.c
+++ b/drivers/pinctrl/pinctrl-imx35.c
@@ -1019,7 +1019,7 @@ static struct platform_driver imx35_pinctrl_driver = {
 	.driver = {
 		.name = "imx35-pinctrl",
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(imx35_pinctrl_of_match),
+		.of_match_table = imx35_pinctrl_of_match,
 	},
 	.probe = imx35_pinctrl_probe,
 	.remove = imx_pinctrl_remove,
-- 
1.7.9.5

