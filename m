Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3HKPEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 11:04:53 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:58787 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab3HKPEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 11:04:52 -0400
Message-ID: <1376233486.13932.1.camel@phoenix>
Subject: [PATCH v2] regulator: da9210: Remove redundant MODULE_ALIAS
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Steve Twiss <stwiss.opensource@diasemi.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 11 Aug 2013 23:04:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The modalias is set by the MODULE_DEVICE_TABLE, thus remove redundant
MODULE_ALIAS.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9210-regulator.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/da9210-regulator.c b/drivers/regulator/da9210-regulator.c
index bf492bc..f0fe54b 100644
--- a/drivers/regulator/da9210-regulator.c
+++ b/drivers/regulator/da9210-regulator.c
@@ -194,4 +194,3 @@ module_i2c_driver(da9210_regulator_driver);
 MODULE_AUTHOR("S Twiss <stwiss.opensource@diasemi.com>");
 MODULE_DESCRIPTION("Regulator device driver for Dialog DA9210");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("i2c:da9210");
-- 
1.8.1.2



