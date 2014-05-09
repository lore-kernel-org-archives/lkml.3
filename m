Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbaEITeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:34:22 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40657 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195AbaEITeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:34:18 -0400
From: srinivas.kandagatla@linaro.org
To: Mike Turquette <mturquette@linaro.org>
Cc: galak@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2] clk: qcom: add clocks necessary for apq8064 sdcc
Date: Fri,  9 May 2014 12:34:05 -0700
Message-Id: <1399664045-18870-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399661305-11641-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1399661305-11641-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds clocks necessary for SD card controller on apq8064 SOC.
Without this patch the clocks are visible to the sdcc driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/clk/qcom/gcc-msm8960.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/qcom/gcc-msm8960.c b/drivers/clk/qcom/gcc-msm8960.c
index f4ffd91..c47a758 100644
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
1.9.1

