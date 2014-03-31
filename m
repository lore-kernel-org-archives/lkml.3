Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaCaNbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:31:34 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54120 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbaCaNb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:31:29 -0400
Message-ID: <1396272676.7843.1.camel@phoenix>
Subject: [PATCH 1/2] mfd: bcm590xx: Fix modalias prefix
From: Axel Lin <axel.lin@ingics.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Matt Porter <mporter@linaro.org>, linux-kernel@vger.kernel.org
Date: Mon, 31 Mar 2014 21:31:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a i2c driver, so uses i2c prefix in modalias.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/bcm590xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/bcm590xx.c b/drivers/mfd/bcm590xx.c
index e9a33c7..40c0dd3 100644
--- a/drivers/mfd/bcm590xx.c
+++ b/drivers/mfd/bcm590xx.c
@@ -90,4 +90,4 @@ module_i2c_driver(bcm590xx_i2c_driver);
 MODULE_AUTHOR("Matt Porter <mporter@linaro.org>");
 MODULE_DESCRIPTION("BCM590xx multi-function driver");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:bcm590xx");
+MODULE_ALIAS("i2c:bcm590xx");
-- 
1.8.3.2



