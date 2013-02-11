Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab3BKOHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:07:33 -0500
Received: from mail-ye0-f181.google.com ([209.85.213.181]:50742 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059Ab3BKOHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:07:32 -0500
From: Fabio Estevam <festevam@gmail.com>
To: mturquette@linaro.org
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] clk: mxs: Fix sparse warnings
Date: Mon, 11 Feb 2013 12:07:16 -0200
Message-Id: <1360591636-10575-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Fix the following sparse warnings:

drivers/clk/mxs/clk.c:17:1: warning: symbol 'mxs_lock' was not declared. Should it be static?
drivers/clk/mxs/clk.c:19:5: warning: symbol 'mxs_clk_wait' was not declared. Should it be static?

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/clk/mxs/clk.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/mxs/clk.c b/drivers/clk/mxs/clk.c
index b24d560..5301bce 100644
--- a/drivers/clk/mxs/clk.c
+++ b/drivers/clk/mxs/clk.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/jiffies.h>
 #include <linux/spinlock.h>
+#include "clk.h"
 
 DEFINE_SPINLOCK(mxs_lock);
 
-- 
1.7.9.5

