Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaFRPST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:18:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45110 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbaFRPSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:18:16 -0400
From: Felipe Balbi <balbi@ti.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Keerthy <j-keerthy@ti.com>, <stable@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 2/2] regulators: TPS65218: Correct the the config register for LDO1
Date: Wed, 18 Jun 2014 10:17:48 -0500
Message-ID: <1403104668-32316-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.0.rc1
In-Reply-To: <1403104668-32316-1-git-send-email-balbi@ti.com>
References: <1403104668-32316-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keerthy <j-keerthy@ti.com>

Correct the the config register for LDO1.

Cc: <stable@vger.kernel.org> # v3.15
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/regulator/tps65218-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index edbc46e..9effe48 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -209,7 +209,7 @@ static const struct regulator_desc regulators[] = {
 			   1, -1, -1, TPS65218_REG_ENABLE1,
 			   TPS65218_ENABLE1_DC6_EN, NULL, NULL, 0, 0),
 	TPS65218_REGULATOR("LDO1", TPS65218_LDO_1, tps65218_ldo1_dcdc34_ops, 64,
-			   TPS65218_REG_CONTROL_DCDC4,
+			   TPS65218_REG_CONTROL_LDO1,
 			   TPS65218_CONTROL_LDO1_MASK, TPS65218_REG_ENABLE2,
 			   TPS65218_ENABLE2_LDO1_EN, NULL, ldo1_dcdc3_ranges,
 			   2, 0),
-- 
2.0.0.rc1

