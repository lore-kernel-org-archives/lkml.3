Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaIKKVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:21:17 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61469 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaIKKVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:21:15 -0400
Message-ID: <1410430870.32479.0.camel@phoenix>
Subject: [PATCH 1/2] regulator: rk808: Remove unused variables
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Doug Anderson <dianders@chromium.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 11 Sep 2014 18:21:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove non-informative comment.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/rk808-regulator.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index d91f2b6..9557428 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -28,32 +28,6 @@
 #define RK808_BUCK4_VSEL_MASK	0xf
 #define RK808_LDO_VSEL_MASK	0x1f
 
-static const int buck_set_vol_base_addr[] = {
-	RK808_BUCK1_ON_VSEL_REG,
-	RK808_BUCK2_ON_VSEL_REG,
-	RK808_BUCK3_CONFIG_REG,
-	RK808_BUCK4_ON_VSEL_REG,
-};
-
-static const int buck_contr_base_addr[] = {
-	RK808_BUCK1_CONFIG_REG,
-	RK808_BUCK2_CONFIG_REG,
-	RK808_BUCK3_CONFIG_REG,
-	RK808_BUCK4_CONFIG_REG,
-};
-
-static const int ldo_set_vol_base_addr[] = {
-	RK808_LDO1_ON_VSEL_REG,
-	RK808_LDO2_ON_VSEL_REG,
-	RK808_LDO3_ON_VSEL_REG,
-	RK808_LDO4_ON_VSEL_REG,
-	RK808_LDO5_ON_VSEL_REG,
-	RK808_LDO6_ON_VSEL_REG,
-	RK808_LDO7_ON_VSEL_REG,
-	RK808_LDO8_ON_VSEL_REG,
-};
-
-/* rk808 voltage number */
 static const struct regulator_linear_range rk808_buck_voltage_ranges[] = {
 	REGULATOR_LINEAR_RANGE(700000, 0, 63, 12500),
 };
-- 
1.9.1



