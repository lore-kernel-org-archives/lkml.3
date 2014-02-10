Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaBJKH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:07:59 -0500
Received: from sauhun.de ([89.238.76.85]:38558 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbaBJKEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:04:39 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/17] i2c: i2c-ocores: deprecate class based instantiation
Date: Mon, 10 Feb 2014 11:04:05 +0100
Message-Id: <1392026654-5343-12-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
References: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warn users that class based instantiation is going away soon in favour
of more robust probing and faster bootup times.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: Peter Korsgaard <jacmet@sunsite.dk>
---

This patch is a suggestion. Looking for an ack by someone who actually uses
the driver.

 drivers/i2c/busses/i2c-ocores.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index c61f37a..f49fe26 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -247,7 +247,7 @@ static const struct i2c_algorithm ocores_algorithm = {
 static struct i2c_adapter ocores_adapter = {
 	.owner		= THIS_MODULE,
 	.name		= "i2c-ocores",
-	.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD,
+	.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD | I2C_CLASS_DEPRECATED,
 	.algo		= &ocores_algorithm,
 };
 
-- 
1.8.5.1

