Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaEXARc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 20:17:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51821 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaEXARB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 20:17:01 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Keerthy <j-keerthy@ti.com>
Subject: [PATCH] mfd: tps65218: Terminate of match table
Date: Fri, 23 May 2014 17:16:52 -0700
Message-Id: <1400890613-5704-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Failure to terminate this match table can lead to boot failures
depending on where the compiler places the match table.

Cc: Keerthy <j-keerthy@ti.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mfd/tps65218.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/tps65218.c b/drivers/mfd/tps65218.c
index a74bfb59f18f..0d256cb002eb 100644
--- a/drivers/mfd/tps65218.c
+++ b/drivers/mfd/tps65218.c
@@ -197,6 +197,7 @@ static struct regmap_irq_chip tps65218_irq_chip = {
 
 static const struct of_device_id of_tps65218_match_table[] = {
 	{ .compatible = "ti,tps65218", },
+	{}
 };
 
 static int tps65218_probe(struct i2c_client *client,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

