Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaGVLLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:11:42 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35273 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaGVLLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:11:40 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/19] mfd: max77686: Fix 'line over 80 chars' warning
Date: Tue, 22 Jul 2014 12:11:07 +0100
Message-Id: <1406027485-15657-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an effort to clean-up the MFD subsystem.

+WARNING: line over 80 characters
+                                      &max77686_rtc_regmap_config);

total: 0 errors, 1 warnings, 299 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max77686.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 8650832..f2bd699 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -166,7 +166,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	i2c_set_clientdata(max77686->rtc, max77686);
 
 	max77686->rtc_regmap = devm_regmap_init_i2c(max77686->rtc,
-						    &max77686_rtc_regmap_config);
+						&max77686_rtc_regmap_config);
 	if (IS_ERR(max77686->rtc_regmap)) {
 		ret = PTR_ERR(max77686->rtc_regmap);
 		dev_err(max77686->dev, "failed to allocate RTC regmap: %d\n",
-- 
1.8.3.2

