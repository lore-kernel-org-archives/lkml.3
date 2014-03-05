Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaCEKCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:02:53 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43470 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaCEKCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:02:50 -0500
Message-ID: <1394013763.16890.1.camel@phoenix>
Subject: [PATCH] regulator: pfuze100: Add PFUZE200 support to Kconfig and
 module description
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Mar 2014 18:02:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/Kconfig              | 6 +++---
 drivers/regulator/pfuze100-regulator.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 4ddfb6c..eb36d8b 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -408,12 +408,12 @@ config REGULATOR_PCF50633
 	 on PCF50633
 
 config REGULATOR_PFUZE100
-	tristate "Freescale PFUZE100 regulator driver"
+	tristate "Freescale PFUZE100/PFUZE200 regulator driver"
 	depends on I2C
 	select REGMAP_I2C
 	help
-	  Say y here to support the regulators found on the Freescale PFUZE100
-	  PMIC.
+	  Say y here to support the regulators found on the Freescale
+	  PFUZE100/PFUZE200 PMIC.
 
 config REGULATOR_RC5T583
 	tristate "RICOH RC5T583 Power regulators"
diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index f87ec70..67e678c 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -527,6 +527,6 @@ static struct i2c_driver pfuze_driver = {
 module_i2c_driver(pfuze_driver);
 
 MODULE_AUTHOR("Robin Gong <b38343@freescale.com>");
-MODULE_DESCRIPTION("Regulator Driver for Freescale PFUZE100 PMIC");
+MODULE_DESCRIPTION("Regulator Driver for Freescale PFUZE100/PFUZE200 PMIC");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("i2c:pfuze100-regulator");
-- 
1.8.1.2



