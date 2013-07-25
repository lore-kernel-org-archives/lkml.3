Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3GYAnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 20:43:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34869 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab3GYAnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 20:43:45 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v1 01/14] clk: fixed-rate: Export clk_fixed_rate_register()
Date: Wed, 24 Jul 2013 17:43:29 -0700
Message-Id: <1374713022-6049-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.840.g6a90778
In-Reply-To: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export this symbol so that modules can register fixed rate
clocks.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk-fixed-rate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index dc58fbd..1ed591a 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -80,6 +80,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 
 	return clk;
 }
+EXPORT_SYMBOL_GPL(clk_register_fixed_rate);
 
 #ifdef CONFIG_OF
 /**
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

