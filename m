Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab3LWGvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 01:51:00 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:32896 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab3LWGu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 01:50:58 -0500
Message-ID: <1387781453.13223.1.camel@phoenix>
Subject: [PATCH] regulator: max14577: Add module alias to support module
 auto-loading
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 23 Dec 2013 14:50:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max14577.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
index 516e8af..b1078ba3 100644
--- a/drivers/regulator/max14577.c
+++ b/drivers/regulator/max14577.c
@@ -270,3 +270,4 @@ module_exit(max14577_regulator_exit);
 MODULE_AUTHOR("Krzysztof Kozlowski <k.kozlowski@samsung.com>");
 MODULE_DESCRIPTION("MAXIM 14577 regulator driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:max14577-regulator");
-- 
1.8.1.2



