Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab3CZEy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 00:54:58 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:42364 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3CZEy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 00:54:57 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, sachin.kamat@linaro.org, patches@linaro.org,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 1/1] mfd: max77686: Use NULL instead of 0
Date: Tue, 26 Mar 2013 10:13:36 +0530
Message-Id: <1364273016-18270-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'data' is a pointer and hence use NULL instead of 0.
Silences the following warning:
drivers/mfd/max77686.c:49:50: warning: Using plain integer as NULL pointer

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/mfd/max77686.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 4d73963..1cbb176 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -46,7 +46,7 @@ static struct regmap_config max77686_regmap_config = {
 
 #ifdef CONFIG_OF
 static struct of_device_id max77686_pmic_dt_match[] = {
-	{.compatible = "maxim,max77686",        .data = 0},
+	{.compatible = "maxim,max77686", .data = NULL},
 	{},
 };
 
-- 
1.7.4.1

