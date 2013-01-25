Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab3AYS0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:26:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49683 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932359Ab3AYS0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:26:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm5102: Fix definition of WM5102_MAX_REGISTER
Date: Fri, 25 Jan 2013 23:53:51 +0800
Message-Id: <1359129231-4672-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated in latest datasheet.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index f183eca..9933034 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1886,7 +1886,7 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 	}
 }
 
-#define WM5102_MAX_REGISTER 0x1a8fff
+#define WM5102_MAX_REGISTER 0x1a9800
 
 const struct regmap_config wm5102_spi_regmap = {
 	.reg_bits = 32,
-- 
1.7.10.4

