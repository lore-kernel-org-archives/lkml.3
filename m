Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaETQxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:53:00 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:59444 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbaETQw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:52:59 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: sboyd@codeaurora.org
Cc: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH] clk: qcom: Fix blsp2_ahb_clk register offset
Date: Tue, 20 May 2014 19:50:54 +0300
Message-Id: <1400604654-27701-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address of the blsp2_ahb_clk register is incorrect. Fix it.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 drivers/clk/qcom/gcc-msm8974.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-msm8974.c b/drivers/clk/qcom/gcc-msm8974.c
index 51d457e..7968ed2 100644
--- a/drivers/clk/qcom/gcc-msm8974.c
+++ b/drivers/clk/qcom/gcc-msm8974.c
@@ -1340,7 +1340,7 @@ static struct clk_branch gcc_blsp1_uart6_apps_clk = {
 };
 
 static struct clk_branch gcc_blsp2_ahb_clk = {
-	.halt_reg = 0x05c4,
+	.halt_reg = 0x0944,
 	.halt_check = BRANCH_HALT_VOTED,
 	.clkr = {
 		.enable_reg = 0x1484,
-- 
1.7.9.5

