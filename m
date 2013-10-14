Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3JNKba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:31:30 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:38895 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab3JNKb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:31:29 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH] clk / clkdev: fix the comments in clk_register_clkdev
Date: Mon, 14 Oct 2013 18:30:09 +0800
Message-Id: <1381746609-21498-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'dev_id' in the comments of clk_register_clkdev should
be 'dev_fmt' here.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/clk/clkdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 442a313..825b52b 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -270,9 +270,9 @@ EXPORT_SYMBOL(clkdev_drop);
  * clk_register_clkdev - register one clock lookup for a struct clk
  * @clk: struct clk to associate with all clk_lookups
  * @con_id: connection ID string on device
- * @dev_id: format string describing device name
+ * @dev_fmt: format string describing device name
  *
- * con_id or dev_id may be NULL as a wildcard, just as in the rest of
+ * con_id or dev_fmt may be NULL as a wildcard, just as in the rest of
  * clkdev.
  *
  * To make things easier for mass registration, we detect error clks
-- 
1.7.9.5

