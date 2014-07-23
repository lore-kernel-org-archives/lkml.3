Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbaGWIrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:47:39 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42363 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaGWIrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:47:37 -0400
Message-ID: <1406105251.666.2.camel@phoenix>
Subject: [PATCH] regulator: s2mps11: Update module description and Kconfig
 to add S2MPU02 support
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jul 2014 16:47:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver also supports S2MPU02 now, thus update module description and
Kconfig accordingly.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/Kconfig   | 4 ++--
 drivers/regulator/s2mps11.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index f5040fc..2dc8289 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -467,10 +467,10 @@ config REGULATOR_S2MPA01
 	 via I2C bus. S2MPA01 has 10 Bucks and 26 LDO outputs.
 
 config REGULATOR_S2MPS11
-	tristate "Samsung S2MPS11/S2MPS14 voltage regulator"
+	tristate "Samsung S2MPS11/S2MPS14/S2MPU02 voltage regulator"
 	depends on MFD_SEC_CORE
 	help
-	 This driver supports a Samsung S2MPS11/S2MPS14 voltage output
+	 This driver supports a Samsung S2MPS11/S2MPS14/S2MPU02 voltage output
 	 regulator via I2C bus. The chip is comprised of high efficient Buck
 	 converters including Dual-Phase Buck converter, Buck-Boost converter,
 	 various LDOs.
diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 2daacc6..b16c53a 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -1045,5 +1045,5 @@ module_exit(s2mps11_pmic_exit);
 
 /* Module information */
 MODULE_AUTHOR("Sangbeom Kim <sbkim73@samsung.com>");
-MODULE_DESCRIPTION("SAMSUNG S2MPS11/S2MPS14 Regulator Driver");
+MODULE_DESCRIPTION("SAMSUNG S2MPS11/S2MPS14/S2MPU02 Regulator Driver");
 MODULE_LICENSE("GPL");
-- 
1.9.1



