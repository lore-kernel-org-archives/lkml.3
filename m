Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaGJIbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:31:52 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48947 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaGJISW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:18:22 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 1/2] clk: qcom: add clocks necessary for apq8064 sdcc
Date: Thu, 10 Jul 2014 09:18:13 +0100
Message-Id: <1404980293-6072-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404980193-5967-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1404980193-5967-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds clocks necessary for SD card controller on apq8064 SOC.
Without this patch the clocks are not visible to the sdcc driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Kumar Gala <galak@codeaurora.org>
---
 drivers/clk/qcom/gcc-msm8960.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/clk/qcom/gcc-msm8960.c b/drivers/clk/qcom/gcc-msm8960.c
index f4ffd91..4cb2927 100644
--- a/drivers/clk/qcom/gcc-msm8960.c
+++ b/drivers/clk/qcom/gcc-msm8960.c
@@ -2876,6 +2876,18 @@ static struct clk_regmap *gcc_apq8064_clks[] = {
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
+	[SDC1_H_CLK] = &sdc1_h_clk.clkr,
+	[SDC2_H_CLK] = &sdc2_h_clk.clkr,
+	[SDC3_H_CLK] = &sdc3_h_clk.clkr,
+	[SDC4_H_CLK] = &sdc4_h_clk.clkr,
 };
 
 static const struct regmap_config gcc_msm8960_regmap_config = {
-- 
1.9.1

