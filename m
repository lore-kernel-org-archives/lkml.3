Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaHDATc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:19:32 -0400
Received: from s87.loopia.se ([194.9.94.112]:29975 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbaHDAT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:19:29 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: sameo@linux.intel.com, lee.jones@linaro.org, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 06/19] mfd: htc-i2cpld: fix %d confusingly prefixed with 0x in format string
Date: Sun,  3 Aug 2014 17:19:15 -0700
Message-Id: <1407111555-14739-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/mfd/htc-i2cpld.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
index b44f020..6bdb78c 100644
--- a/drivers/mfd/htc-i2cpld.c
+++ b/drivers/mfd/htc-i2cpld.c
@@ -404,7 +404,7 @@ static int htcpld_register_chip_i2c(
 	}
 
 	i2c_set_clientdata(client, chip);
-	snprintf(client->name, I2C_NAME_SIZE, "Chip_0x%d", client->addr);
+	snprintf(client->name, I2C_NAME_SIZE, "Chip_0x%x", client->addr);
 	chip->client = client;
 
 	/* Reset the chip */
-- 
2.0.0.526.g5318336

