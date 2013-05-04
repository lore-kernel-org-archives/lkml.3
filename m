Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab3EDKvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 06:51:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56008 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab3EDKvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 06:51:15 -0400
Message-ID: <1367664669.25532.1.camel@phoenix>
Subject: [PATCH] power_supply: pm2301_charger: Fix module alias prefix
From: Axel Lin <axel.lin@ingics.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Date: Sat, 04 May 2013 18:51:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is a i2c driver, use "i2c" rather than "platform" prefix for module
alias.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/power/pm2301_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index a441751..fef56e2 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -1269,5 +1269,5 @@ module_exit(pm2xxx_charger_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Rajkumar kasirajan, Olivier Launay");
-MODULE_ALIAS("platform:pm2xxx-charger");
+MODULE_ALIAS("i2c:pm2xxx-charger");
 MODULE_DESCRIPTION("PM2xxx charger management driver");
-- 
1.8.1.2



