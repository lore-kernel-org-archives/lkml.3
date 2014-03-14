Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbaCNB6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 21:58:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37556 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbaCNB6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 21:58:01 -0400
Message-ID: <1394762274.8460.1.camel@phoenix>
Subject: [PATCH 1/3] regulator: bcm590xx: Make the modalias matches the
 driver name
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Matt Porter <mporter@linaro.org>, Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 14 Mar 2014 09:57:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/bcm590xx-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/bcm590xx-regulator.c b/drivers/regulator/bcm590xx-regulator.c
index e6b2e8e..d12d6d6 100644
--- a/drivers/regulator/bcm590xx-regulator.c
+++ b/drivers/regulator/bcm590xx-regulator.c
@@ -410,4 +410,4 @@ module_platform_driver(bcm590xx_regulator_driver);
 MODULE_AUTHOR("Matt Porter <mporter@linaro.org>");
 MODULE_DESCRIPTION("BCM590xx voltage regulator driver");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:bcm590xx-regulator");
+MODULE_ALIAS("platform:bcm590xx-vregs");
-- 
1.8.1.2



