Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab3JODtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 23:49:53 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54061 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab3JODtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 23:49:50 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 2/6] mfd: tps65217: Remove redundant of_match_ptr
Date: Tue, 15 Oct 2013 09:18:47 +0530
Message-Id: <1381808931-3323-2-git-send-email-sachin.kamat@linaro.org>
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
 drivers/mfd/tps65217.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index b8f4864..b7be0b2 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -245,7 +245,7 @@ static struct i2c_driver tps65217_driver = {
 	.driver		= {
 		.name	= "tps65217",
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(tps65217_of_match),
+		.of_match_table = tps65217_of_match,
 	},
 	.id_table	= tps65217_id_table,
 	.probe		= tps65217_probe,
-- 
1.7.9.5

