Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab3L3Slj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 13:41:39 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:45982 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3L3Sld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 13:41:33 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regulator: pfuze100-regulator: Fix MODULE_ALIAS()
Date: Mon, 30 Dec 2013 16:41:22 -0200
Message-Id: <1388428882-28217-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

We should use 'platform' in the MODULE_ALIAS for the regulator.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/pfuze100-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 0c511ae..04c6267 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -434,4 +434,4 @@ module_i2c_driver(pfuze_driver);
 MODULE_AUTHOR("Robin Gong <b38343@freescale.com>");
 MODULE_DESCRIPTION("Regulator Driver for Freescale PFUZE100 PMIC");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("i2c:pfuze100-regulator");
+MODULE_ALIAS("platform:pfuze100-regulator");
-- 
1.8.1.2

