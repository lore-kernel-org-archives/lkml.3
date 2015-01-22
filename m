Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbbAVTeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:34:24 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48213 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbbAVTeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:34:21 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] clk: ux500: Drop use of clk-private.h
Date: Thu, 22 Jan 2015 11:34:19 -0800
Message-Id: <1421955259-8875-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.3.0.rc0.46.gbe498cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These drivers don't need to include clk-private.h. Remove the
include.

Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/ux500/clk-prcc.c  | 1 -
 drivers/clk/ux500/clk-prcmu.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/clk/ux500/clk-prcc.c b/drivers/clk/ux500/clk-prcc.c
index bd4769a84485..0e950769ed03 100644
--- a/drivers/clk/ux500/clk-prcc.c
+++ b/drivers/clk/ux500/clk-prcc.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/clk-provider.h>
-#include <linux/clk-private.h>
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/err.h>
diff --git a/drivers/clk/ux500/clk-prcmu.c b/drivers/clk/ux500/clk-prcmu.c
index e2d63bc47436..bf63c96acb1a 100644
--- a/drivers/clk/ux500/clk-prcmu.c
+++ b/drivers/clk/ux500/clk-prcmu.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/clk-provider.h>
-#include <linux/clk-private.h>
 #include <linux/mfd/dbx500-prcmu.h>
 #include <linux/slab.h>
 #include <linux/io.h>
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

