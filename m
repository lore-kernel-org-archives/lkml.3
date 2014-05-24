Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaEXARr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 20:17:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51817 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaEXARB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 20:17:01 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] clk: u300: Terminate of match table
Date: Fri, 23 May 2014 17:16:51 -0700
Message-Id: <1400890613-5704-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Failure to terminate this match table can lead to boot failures
depending on where the compiler places the match table.

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk-u300.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk-u300.c b/drivers/clk/clk-u300.c
index 3efbdd078d14..406bfc1375b2 100644
--- a/drivers/clk/clk-u300.c
+++ b/drivers/clk/clk-u300.c
@@ -1168,6 +1168,7 @@ static const struct of_device_id u300_clk_match[] __initconst = {
 		.compatible = "stericsson,u300-syscon-mclk",
 		.data = of_u300_syscon_mclk_init,
 	},
+	{}
 };
 
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

