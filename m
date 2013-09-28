Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab3I1MJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 08:09:46 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48570 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3I1MJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 08:09:20 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 06/11] pinctrl: imx6dl: Remove redundant of_match_ptr
Date: Sat, 28 Sep 2013 17:38:53 +0530
Message-Id: <1380370138-3513-6-git-send-email-sachin.kamat@linaro.org>
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
 drivers/pinctrl/pinctrl-imx6dl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx6dl.c b/drivers/pinctrl/pinctrl-imx6dl.c
index a76b724..db2a148 100644
--- a/drivers/pinctrl/pinctrl-imx6dl.c
+++ b/drivers/pinctrl/pinctrl-imx6dl.c
@@ -474,7 +474,7 @@ static struct platform_driver imx6dl_pinctrl_driver = {
 	.driver = {
 		.name = "imx6dl-pinctrl",
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(imx6dl_pinctrl_of_match),
+		.of_match_table = imx6dl_pinctrl_of_match,
 	},
 	.probe = imx6dl_pinctrl_probe,
 	.remove = imx_pinctrl_remove,
-- 
1.7.9.5

