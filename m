Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3A3KWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:22:44 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53663 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3A3KWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:22:39 -0500
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: linux@roeck-us.net, khali@linux-fr.org, lm-sensors@lm-sensors.org,
        sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        Hongbo Zhang <hongbo.zhang@linaro.org>
Subject: [PATCH 1/2] ARM: ux500: rename ab8500 to abx500 for hwmon driver
Date: Wed, 30 Jan 2013 18:21:27 +0800
Message-Id: <1359541288-6657-2-git-send-email-hongbo.zhang@linaro.org>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359541288-6657-1-git-send-email-hongbo.zhang@linaro.org>
References: <1359541288-6657-1-git-send-email-hongbo.zhang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are using a generic abx500 hwmon layer, so rename specific ab8500 to generic
abx500 for hwmon device and driver matching.

Signed-off-by: Hongbo Zhang <hongbo.zhang@linaro.org>
---
 drivers/mfd/ab8500-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index e1650ba..579753f 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -922,7 +922,7 @@ static struct resource ab8505_iddet_resources[] = {
 
 static struct resource ab8500_temp_resources[] = {
 	{
-		.name  = "AB8500_TEMP_WARM",
+		.name  = "ABX500_TEMP_WARM",
 		.start = AB8500_INT_TEMP_WARM,
 		.end   = AB8500_INT_TEMP_WARM,
 		.flags = IORESOURCE_IRQ,
@@ -998,8 +998,8 @@ static struct mfd_cell abx500_common_devs[] = {
 		.of_compatible = "stericsson,ab8500-denc",
 	},
 	{
-		.name = "ab8500-temp",
-		.of_compatible = "stericsson,ab8500-temp",
+		.name = "abx500-temp",
+		.of_compatible = "stericsson,abx500-temp",
 		.num_resources = ARRAY_SIZE(ab8500_temp_resources),
 		.resources = ab8500_temp_resources,
 	},
-- 
1.8.0

