Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3LUKXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:23:34 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39231 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3LUKXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:23:33 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org
Subject: [PATCH 1/1] mfd: max14577: Remove redundant of_match_ptr helper
Date: Sat, 21 Dec 2013 15:50:16 +0530
Message-Id: <1387621216-9745-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'max14577_dt_match' is always compiled in. Hence the
helper macro is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/max14577.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index a5e1c370c609..ac514fb2b877 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -221,7 +221,7 @@ static struct i2c_driver max14577_i2c_driver = {
 		.name = "max14577",
 		.owner = THIS_MODULE,
 		.pm = &max14577_pm,
-		.of_match_table = of_match_ptr(max14577_dt_match),
+		.of_match_table = max14577_dt_match,
 	},
 	.probe = max14577_i2c_probe,
 	.remove = max14577_i2c_remove,
-- 
1.7.9.5

