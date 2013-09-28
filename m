Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3I1MPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 08:15:01 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64192 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3I1MO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 08:14:58 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org
Subject: [PATCH 1/5] mfd: max8925: Remove redundant of_match_ptr
Date: Sat, 28 Sep 2013 17:44:45 +0530
Message-Id: <1380370489-5488-1-git-send-email-sachin.kamat@linaro.org>
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

