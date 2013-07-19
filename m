Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139Ab3GSRRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:17:10 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:41031 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab3GSRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:17:06 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 1/2] clk/zynq/pll: Fix documentation for PLL register function
Date: Fri, 19 Jul 2013 10:16:44 -0700
Message-Id: <1374254205-9912-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clk/zynq/pll.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/zynq/pll.c b/drivers/clk/zynq/pll.c
index 47e307c..67f1b5e 100644
--- a/drivers/clk/zynq/pll.c
+++ b/drivers/clk/zynq/pll.c
@@ -182,7 +182,12 @@ static const struct clk_ops zynq_pll_ops = {
 
 /**
  * clk_register_zynq_pll() - Register PLL with the clock framework
- * @np	Pointer to the DT device node
+ * @name	PLL name
+ * @parent	Parent clock name
+ * @pll_ctrl	Pointer to PLL control register
+ * @pll_status	Pointer to PLL status register
+ * @lock_index	Bit index to this PLL's lock status bit in @pll_status
+ * @lock	Register lock
  */
 struct clk *clk_register_zynq_pll(const char *name, const char *parent,
 		void __iomem *pll_ctrl, void __iomem *pll_status, u8 lock_index,
-- 
1.8.3.3

