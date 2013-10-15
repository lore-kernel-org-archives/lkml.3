Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab3JODtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 23:49:49 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64044 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab3JODts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 23:49:48 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH Resend 1/6] mfd: max8925: Remove redundant of_match_ptr
Date: Tue, 15 Oct 2013 09:18:46 +0530
Message-Id: <1381808931-3323-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure of_match_ptr() protects is always compiled in.
Hence of_match_ptr() is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/max8925-i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
index de7fb80..176aa26 100644
--- a/drivers/mfd/max8925-i2c.c
+++ b/drivers/mfd/max8925-i2c.c
@@ -238,7 +238,7 @@ static struct i2c_driver max8925_driver = {
 		.name	= "max8925",
 		.owner	= THIS_MODULE,
 		.pm     = &max8925_pm_ops,
-		.of_match_table = of_match_ptr(max8925_dt_ids),
+		.of_match_table = max8925_dt_ids,
 	},
 	.probe		= max8925_probe,
 	.remove		= max8925_remove,
-- 
1.7.9.5

