Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3I1MPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 08:15:11 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:39779 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3I1MPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 08:15:06 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org
Subject: [PATCH 4/5] mfd: ti_am335x_tscadc: Remove redundant of_match_ptr
Date: Sat, 28 Sep 2013 17:44:48 +0530
Message-Id: <1380370489-5488-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380370489-5488-1-git-send-email-sachin.kamat@linaro.org>
References: <1380370489-5488-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure of_match_ptr() protects is always compiled in.
Hence of_match_ptr() is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/ti_am335x_tscadc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index a3685d6..e5a40e8 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -328,7 +328,7 @@ static struct platform_driver ti_tscadc_driver = {
 		.name   = "ti_am3359-tscadc",
 		.owner	= THIS_MODULE,
 		.pm	= TSCADC_PM_OPS,
-		.of_match_table = of_match_ptr(ti_tscadc_dt_ids),
+		.of_match_table = ti_tscadc_dt_ids,
 	},
 	.probe	= ti_tscadc_probe,
 	.remove	= ti_tscadc_remove,
-- 
1.7.9.5

