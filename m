Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3DZMSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:18:07 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:53418 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3DZMSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:18:03 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 3/5] mfd: ab8500: drop references to ab8500-leds
Date: Fri, 26 Apr 2013 14:17:16 +0200
Message-Id: <1366978638-967-4-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1366978638-967-1-git-send-email-fabio.baltieri@linaro.org>
References: <1366978638-967-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ab8500-leds driver has never been upstreamed and was replaced by a
PWM framework based driver, so these references are not needed anymore.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/mfd/ab8500-core.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 8e8a016..dd41ae2 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1089,10 +1089,6 @@ static struct mfd_cell ab8500_devs[] = {
 		.id = 3,
 	},
 	{
-		.name = "ab8500-leds",
-		.of_compatible = "stericsson,ab8500-leds",
-	},
-	{
 		.name = "ab8500-denc",
 		.of_compatible = "stericsson,ab8500-denc",
 	},
@@ -1161,9 +1157,6 @@ static struct mfd_cell ab9540_devs[] = {
 		.id = 1,
 	},
 	{
-		.name = "ab8500-leds",
-	},
-	{
 		.name = "abx500-temp",
 		.num_resources = ARRAY_SIZE(ab8500_temp_resources),
 		.resources = ab8500_temp_resources,
@@ -1231,9 +1224,6 @@ static struct mfd_cell ab8505_devs[] = {
 		.id = 1,
 	},
 	{
-		.name = "ab8500-leds",
-	},
-	{
 		.name = "ab8500-gpio",
 	},
 	{
@@ -1294,9 +1284,6 @@ static struct mfd_cell ab8540_devs[] = {
 		.id = 1,
 	},
 	{
-		.name = "ab8500-leds",
-	},
-	{
 		.name = "abx500-temp",
 		.num_resources = ARRAY_SIZE(ab8500_temp_resources),
 		.resources = ab8500_temp_resources,
-- 
1.8.1.3

