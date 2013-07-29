Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab3G2ETg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:19:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42339 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3G2ETe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:19:34 -0400
Message-ID: <1375071569.4147.1.camel@phoenix>
Subject: [PATCH] regulator: pfuze100: Fix module alias prefix
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Jul 2013 12:19:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c drivers use "i2c:" prefix for module alias.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/pfuze100-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index cd136ff..e9e8ae3 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -451,4 +451,4 @@ module_i2c_driver(pfuze_driver);
 
 MODULE_AUTHOR("Robin Gong <b38343@freescale.com>");
 MODULE_DESCRIPTION("Regulator Driver for Freescale PFUZE100 PMIC");
-MODULE_ALIAS("pfuze100-regulator");
+MODULE_ALIAS("i2c:pfuze100-regulator");
-- 
1.8.1.2



