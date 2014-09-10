Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaIJAoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 20:44:44 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35084 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaIJAol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 20:44:41 -0400
Message-ID: <1410309876.18009.0.camel@phoenix>
Subject: [PATCH] regulator: isl9305: REGULATOR_ISL9305 needs to select
 REGMAP_I2C
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 10 Sep 2014 08:44:36 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ERROR: "devm_regmap_init_i2c" [drivers/regulator/isl9305.ko] undefined!

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 2b98a34..2419fe4 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -254,6 +254,7 @@ config REGULATOR_HI6421
 config REGULATOR_ISL9305
 	tristate "Intersil ISL9305 regulator"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  This driver supports ISL9305 voltage regulator chip.
 
-- 
1.9.1



