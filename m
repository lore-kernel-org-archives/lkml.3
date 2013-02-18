Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654Ab3BRFPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:15:45 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36777 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab3BRFPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:15:43 -0500
From: J Keerthy <j-keerthy@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: <j-keerthy@ti.com>, <gg@slimlogic.co.uk>
Subject: [PATCH 4/4] regulator: palmas: Change the DT node property names to follow the convention
Date: Mon, 18 Feb 2013 10:44:20 +0530
Message-ID: <1361164460-3251-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT node properties should not have "_". Replacing them by "-".

Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 drivers/regulator/palmas-regulator.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 22c6ae2..a7d1d53 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -551,17 +551,17 @@ static void palmas_dt_to_pdata(struct device *dev,
 				sizeof(struct palmas_reg_init), GFP_KERNEL);
 
 		ret = of_property_read_u32(palmas_matches[idx].of_node,
-				"ti,warm_reset", &prop);
+				"ti,warm-reset", &prop);
 		if (!ret)
 			pdata->reg_init[idx]->warm_reset = prop;
 
 		ret = of_property_read_u32(palmas_matches[idx].of_node,
-				"ti,roof_floor", &prop);
+				"ti,roof-floor", &prop);
 		if (!ret)
 			pdata->reg_init[idx]->roof_floor = prop;
 
 		ret = of_property_read_u32(palmas_matches[idx].of_node,
-				"ti,mode_sleep", &prop);
+				"ti,mode-sleep", &prop);
 		if (!ret)
 			pdata->reg_init[idx]->mode_sleep = prop;
 
@@ -576,7 +576,7 @@ static void palmas_dt_to_pdata(struct device *dev,
 			pdata->reg_init[idx]->vsel = prop;
 	}
 
-	ret = of_property_read_u32(node, "ti,ldo6_vibrator", &prop);
+	ret = of_property_read_u32(node, "ti,ldo6-vibrator", &prop);
 	if (!ret)
 		pdata->ldo6_vibrator = prop;
 }
-- 
1.7.5.4

