Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab3JODus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 23:50:48 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:44294 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471Ab3JODty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 23:49:54 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 4/6] mfd: ti_am335x_tscadc: Remove redundant of_match_ptr
Date: Tue, 15 Oct 2013 09:18:49 +0530
Message-Id: <1381808931-3323-4-git-send-email-sachin.kamat@linaro.org>
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

