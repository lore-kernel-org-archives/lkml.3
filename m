Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaIGPXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 11:23:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55337 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaIGPXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 11:23:12 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Sun,  7 Sep 2014 16:22:46 +0100
Message-Id: <1410103366-14503-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 86.177.228.237
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: tps65217: Remove unused driver_data from of_match table
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

We don't ever reference the driver_data we supply so remove it.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/tps65217-regulator.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index d58db72..89593a6 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -171,13 +171,13 @@ static const struct regulator_desc regulators[] = {
 
 #ifdef CONFIG_OF
 static struct of_regulator_match reg_matches[] = {
-	{ .name = "dcdc1", .driver_data = (void *)TPS65217_DCDC_1 },
-	{ .name = "dcdc2", .driver_data = (void *)TPS65217_DCDC_2 },
-	{ .name = "dcdc3", .driver_data = (void *)TPS65217_DCDC_3 },
-	{ .name = "ldo1", .driver_data = (void *)TPS65217_LDO_1 },
-	{ .name = "ldo2", .driver_data = (void *)TPS65217_LDO_2 },
-	{ .name = "ldo3", .driver_data = (void *)TPS65217_LDO_3 },
-	{ .name = "ldo4", .driver_data = (void *)TPS65217_LDO_4 },
+	{ .name = "dcdc1" },
+	{ .name = "dcdc2" },
+	{ .name = "dcdc3" },
+	{ .name = "ldo1"  },
+	{ .name = "ldo2"  },
+	{ .name = "ldo3"  },
+	{ .name = "ldo4"  },
 };
 
 static struct tps65217_board *tps65217_parse_dt(struct platform_device *pdev)
-- 
2.1.0

