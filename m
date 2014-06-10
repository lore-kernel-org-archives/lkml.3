Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaFJU6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:58:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43041 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbaFJU6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:58:30 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 1/2] clk: qcom: add clocks necessary for apq8064 sdcc
Date: Tue, 10 Jun 2014 13:58:25 -0700
Message-Id: <1402433906-19309-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1402433906-19309-1-git-send-email-sboyd@codeaurora.org>
References: <1402433906-19309-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds clocks necessary for SD card controller on apq8064 SOC.
Without this patch the clocks are visible to the sdcc driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/gcc-msm8960.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/qcom/gcc-msm8960.c b/drivers/clk/qcom/gcc-msm8960.c
index f4ffd91901f8..c47a75829b2b 100644
--- a/drivers/clk/qcom/gcc-msm8960.c
+++ b/drivers/clk/qcom/gcc-msm8960.c
@@ -2876,6 +2876,14 @@ static struct clk_regmap *gcc_apq8064_clks[] = {
 	[GSBI7_QUP_SRC] = &gsbi7_qup_src.clkr,
 	[GSBI7_QUP_CLK] = &gsbi7_qup_clk.clkr,
 	[GSBI7_H_CLK] = &gsbi7_h_clk.clkr,
+	[SDC1_SRC] = &sdc1_src.clkr,
+	[SDC1_CLK] = &sdc1_clk.clkr,
+	[SDC2_SRC] = &sdc2_src.clkr,
+	[SDC2_CLK] = &sdc2_clk.clkr,
+	[SDC3_SRC] = &sdc3_src.clkr,
+	[SDC3_CLK] = &sdc3_clk.clkr,
+	[SDC4_SRC] = &sdc4_src.clkr,
+	[SDC4_CLK] = &sdc4_clk.clkr,
 };
 
 static const struct regmap_config gcc_msm8960_regmap_config = {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

