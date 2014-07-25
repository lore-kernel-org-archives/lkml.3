Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934860AbaGYSJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:09:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55055 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaGYSJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:09:30 -0400
From: Mark Brown <broonie@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Fri, 25 Jul 2014 19:09:17 +0100
Message-Id: <1406311757-2834-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.0.1
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: Add missing statics for stub functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

So we don't get multiple definitions.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 include/linux/regulator/consumer.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 0b1c8d09a6b1..a5937148f8a1 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -460,20 +460,20 @@ static inline int regulator_allow_bypass(struct regulator *regulator,
 	return 0;
 }
 
-struct regmap *regulator_get_regmap(struct regulator *regulator)
+static struct regmap *regulator_get_regmap(struct regulator *regulator)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
-int regulator_get_hardware_vsel_register(struct regulator *regulator,
-					 unsigned *vsel_reg,
-					 unsigned *vsel_mask)
+static int regulator_get_hardware_vsel_register(struct regulator *regulator,
+						unsigned *vsel_reg,
+						unsigned *vsel_mask)
 {
 	return -EOPNOTSUPP;
 }
 
-int regulator_list_hardware_vsel(struct regulator *regulator,
-				 unsigned selector)
+static int regulator_list_hardware_vsel(struct regulator *regulator,
+					unsigned selector)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.0.1

