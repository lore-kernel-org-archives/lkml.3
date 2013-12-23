Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab3LWTfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 14:35:50 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:34585 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372Ab3LWTft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 14:35:49 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: b38343@freescale.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regulator: Kconfig: Improve PFUZE100 entry text
Date: Mon, 23 Dec 2013 17:35:35 -0200
Message-Id: <1387827335-10109-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Make PFUZE100 entry consistent with other Freescale PMIC entries, so that now
we can have:

	<*>   Freescale MC13783 regulator driver
	<*>   Freescale MC13892 regulator driver 
	<*>   Freescale PFUZE100 regulator driver

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 7faedb7..8fe18bf 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -391,7 +391,7 @@ config REGULATOR_PCF50633
 	 on PCF50633
 
 config REGULATOR_PFUZE100
-	tristate "Support regulators on Freescale PFUZE100 PMIC"
+	tristate "Freescale PFUZE100 regulator driver"
 	depends on I2C
 	select REGMAP_I2C
 	help
-- 
1.8.1.2

