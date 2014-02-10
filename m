Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaBJKFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:05:47 -0500
Received: from sauhun.de ([89.238.76.85]:38572 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaBJKEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:04:47 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 17/17] i2c: i2c-xiic: deprecate class based instantiation
Date: Mon, 10 Feb 2014 11:04:11 +0100
Message-Id: <1392026654-5343-18-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
References: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warn users that class based instantiation is going away soon in favour
of more robust probing and faster bootup times.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---

This patch is a suggestion. Looking for an ack by someone who actually uses
the driver.

 drivers/i2c/busses/i2c-xiic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index fc2716a..6bda167 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -682,7 +682,7 @@ static const struct i2c_algorithm xiic_algorithm = {
 static struct i2c_adapter xiic_adapter = {
 	.owner		= THIS_MODULE,
 	.name		= DRIVER_NAME,
-	.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD,
+	.class		= I2C_CLASS_HWMON | I2C_CLASS_SPD | I2C_CLASS_DEPRECATED,
 	.algo		= &xiic_algorithm,
 };
 
-- 
1.8.5.1

