Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab3I3I5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:57:32 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38457 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3I3I51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:57:27 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 1/2] regulator: ti-abb: Remove redundant of_match_ptr
Date: Mon, 30 Sep 2013 14:27:13 +0530
Message-Id: <1380531434-15875-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure of_match_ptr() protects is always compiled in.
Hence of_match_ptr() is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/ti-abb-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index 8c2a819..64d6322 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -855,7 +855,7 @@ static struct platform_driver ti_abb_driver = {
 	.driver = {
 		   .name = "ti_abb",
 		   .owner = THIS_MODULE,
-		   .of_match_table = of_match_ptr(ti_abb_of_match),
+		   .of_match_table = ti_abb_of_match,
 		   },
 };
 module_platform_driver(ti_abb_driver);
-- 
1.7.9.5

