Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968072Ab3HIQ0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:26:06 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41524 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934409Ab3HIQ0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:26:04 -0400
Message-ID: <1376065558.7023.1.camel@phoenix>
Subject: [PATCH] regulator: da9210: Remove redundant MODULE_ALIAS
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Steve Twiss <stwiss.opensource@diasemi.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 10 Aug 2013 00:25:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The modalias is set by the MODULE_DEVICE_TABLE, thus remove redundant
MODULE_ALIAS. Also Fix trivial typo for the author name.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9210-regulator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/da9210-regulator.c b/drivers/regulator/da9210-regulator.c
index bf492bc..1597bf8 100644
--- a/drivers/regulator/da9210-regulator.c
+++ b/drivers/regulator/da9210-regulator.c
@@ -191,7 +191,6 @@ static struct i2c_driver da9210_regulator_driver = {
 
 module_i2c_driver(da9210_regulator_driver);
 
-MODULE_AUTHOR("S Twiss <stwiss.opensource@diasemi.com>");
+MODULE_AUTHOR("Steve Twiss <stwiss.opensource@diasemi.com>");
 MODULE_DESCRIPTION("Regulator device driver for Dialog DA9210");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("i2c:da9210");
-- 
1.8.1.2



