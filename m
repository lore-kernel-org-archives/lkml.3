Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3CFLGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:06:19 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:41168 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab3CFLGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:06:15 -0500
From: Nikolay Balandin <n.a.balandin@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Nikolay Balandin <nbalandin@dev.rtsoft.ru>
Subject: [PATCH 1/1] Add TI TCA9554 to supported devices table
Date: Wed,  6 Mar 2013 15:06:44 +0400
Message-Id: <1362568004-28927-1-git-send-email-n.a.balandin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>


Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
---
 drivers/gpio/gpio-pcf857x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index a19b745..a965620 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -45,6 +45,7 @@ static const struct i2c_device_id pcf857x_id[] = {
 	{ "pca9675", 16 },
 	{ "max7328", 8 },
 	{ "max7329", 8 },
+	{ "tca9554", 8 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, pcf857x_id);
-- 
1.7.9.5

