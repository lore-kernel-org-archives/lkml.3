Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3BRFPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:15:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53123 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab3BRFPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:15:30 -0500
From: J Keerthy <j-keerthy@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: <j-keerthy@ti.com>, <gg@slimlogic.co.uk>
Subject: [PATCH 3/4] regulator: palmas: Removing duplicated code
Date: Mon, 18 Feb 2013 10:44:06 +0530
Message-ID: <1361164446-3216-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing duplicate assignment in the existing code.

Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 drivers/regulator/palmas-regulator.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index c9e912f..22c6ae2 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -566,11 +566,6 @@ static void palmas_dt_to_pdata(struct device *dev,
 			pdata->reg_init[idx]->mode_sleep = prop;
 
 		ret = of_property_read_u32(palmas_matches[idx].of_node,
-				"ti,warm_reset", &prop);
-		if (!ret)
-			pdata->reg_init[idx]->warm_reset = prop;
-
-		ret = of_property_read_u32(palmas_matches[idx].of_node,
 				"ti,tstep", &prop);
 		if (!ret)
 			pdata->reg_init[idx]->tstep = prop;
-- 
1.7.5.4

