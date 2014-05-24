Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaEXARs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 20:17:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51813 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaEXARB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 20:17:01 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Subject: [PATCH] clk: st: Terminate of match table
Date: Fri, 23 May 2014 17:16:50 -0700
Message-Id: <1400890613-5704-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Failure to terminate this match table can lead to boot failures
depending on where the compiler places the match table.

Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/st/clkgen-pll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/st/clkgen-pll.c b/drivers/clk/st/clkgen-pll.c
index bca0a0badbfa..2f7da5faa6d7 100644
--- a/drivers/clk/st/clkgen-pll.c
+++ b/drivers/clk/st/clkgen-pll.c
@@ -653,6 +653,7 @@ static struct of_device_id c32_gpu_pll_of_match[] = {
 		.compatible = "st,stih416-gpu-pll-c32",
 		.data = &st_pll1200c32_gpu_416,
 	},
+	{}
 };
 
 static void __init clkgengpu_c32_pll_setup(struct device_node *np)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

