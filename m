Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab3CYOfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:35:19 -0400
Received: from multi.imgtec.com ([194.200.65.239]:8665 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab3CYOfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:35:18 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/1] clk: fix clk_mux::flags kerneldoc
Date: Mon, 25 Mar 2013 14:35:07 +0000
Message-ID: <1364222107-1079-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_25_14_35_16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kerneldoc comment for struct clk_mux documented the non-existent
num_clks instead of flags. Correct this.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 include/linux/clk-provider.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index cdad3ce..e7504d5 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -276,7 +276,7 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
  * @reg:	register controlling multiplexer
  * @shift:	shift to multiplexer bit field
  * @width:	width of mutliplexer bit field
- * @num_clks:	number of parent clocks
+ * @flags:	hardware-specific flags
  * @lock:	register lock
  *
  * Clock with multiple selectable parents.  Implements .get_parent, .set_parent
-- 
1.8.1.2


