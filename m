Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3I1MJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 08:09:09 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33303 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3I1MJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 08:09:07 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 01/11] pinctrl: at91: Remove redundant of_match_ptr
Date: Sat, 28 Sep 2013 17:38:48 +0530
Message-Id: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure of_match_ptr() protects is always compiled in.
Hence of_match_ptr() is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-at91.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index f350fd2..2673ce3 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1671,7 +1671,7 @@ static struct platform_driver at91_gpio_driver = {
 	.driver = {
 		.name = "gpio-at91",
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(at91_gpio_of_match),
+		.of_match_table = at91_gpio_of_match,
 	},
 	.probe = at91_gpio_probe,
 };
@@ -1680,7 +1680,7 @@ static struct platform_driver at91_pinctrl_driver = {
 	.driver = {
 		.name = "pinctrl-at91",
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(at91_pinctrl_of_match),
+		.of_match_table = at91_pinctrl_of_match,
 	},
 	.probe = at91_pinctrl_probe,
 	.remove = at91_pinctrl_remove,
-- 
1.7.9.5

