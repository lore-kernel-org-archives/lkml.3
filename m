Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaGVLLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:11:44 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58359 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbaGVLLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:11:41 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/19] mfd: max8925-i2c: Fix 'blank line after declarations' warning
Date: Tue, 22 Jul 2014 12:11:08 +0100
Message-Id: <1406027485-15657-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an effort to clean-up the MFD subsystem.

WARNING: Missing a blank line after declarations
+       int ret;
+       ret = i2c_add_driver(&max8925_driver);

total: 0 errors, 1 warnings, 275 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max8925-i2c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
index a83eed5..ecbe78e 100644
--- a/drivers/mfd/max8925-i2c.c
+++ b/drivers/mfd/max8925-i2c.c
@@ -257,9 +257,11 @@ static struct i2c_driver max8925_driver = {
 static int __init max8925_i2c_init(void)
 {
 	int ret;
+
 	ret = i2c_add_driver(&max8925_driver);
 	if (ret != 0)
 		pr_err("Failed to register MAX8925 I2C driver: %d\n", ret);
+
 	return ret;
 }
 subsys_initcall(max8925_i2c_init);
-- 
1.8.3.2

