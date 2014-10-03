Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaJCPw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:52:58 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51918 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbaJCPw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:52:57 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: ux500: Remove unused includes of linux/clk-private.h
Date: Fri,  3 Oct 2014 17:52:46 +0200
Message-Id: <1412351566-29344-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/ux500/clk-prcc.c  | 1 -
 drivers/clk/ux500/clk-prcmu.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/clk/ux500/clk-prcc.c b/drivers/clk/ux500/clk-prcc.c
index bd4769a..0e95076 100644
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
index e2d63bc..bf63c96 100644
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
1.9.3

