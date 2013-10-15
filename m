Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab3JODtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 23:49:55 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50647 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454Ab3JODtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 23:49:53 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 3/6] mfd: 88pm860x: Remove redundant of_match_ptr
Date: Tue, 15 Oct 2013 09:18:48 +0530
Message-Id: <1381808931-3323-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381808931-3323-1-git-send-email-sachin.kamat@linaro.org>
References: <1381808931-3323-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure of_match_ptr() protects is always compiled in.
Hence of_match_ptr() is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/88pm860x-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 7ebe9ef..c9b1f64 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -1247,7 +1247,7 @@ static struct i2c_driver pm860x_driver = {
 		.name	= "88PM860x",
 		.owner	= THIS_MODULE,
 		.pm     = &pm860x_pm_ops,
-		.of_match_table	= of_match_ptr(pm860x_dt_ids),
+		.of_match_table	= pm860x_dt_ids,
 	},
 	.probe		= pm860x_probe,
 	.remove		= pm860x_remove,
-- 
1.7.9.5

