Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaJNODM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:03:12 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:35072 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbaJNODK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:03:10 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Tero Kristo <t-kristo@ti.com>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] CLK: TI: Remove unused includes of linux/clk-private.h
Date: Tue, 14 Oct 2014 16:02:43 +0200
Message-Id: <1413295363-22193-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because they are unused, and there's plans to remove that header in the near
future.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

---

v2:	* Add rationale to commit message
	* Include clk-provider.h in each file that uses it, instead of in
	  clk/ti.h
---
 drivers/clk/ti/clk-44xx.c | 2 +-
 drivers/clk/ti/clk-54xx.c | 2 +-
 drivers/clk/ti/clk-7xx.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/ti/clk-44xx.c b/drivers/clk/ti/clk-44xx.c
index 02517a8..3694615 100644
--- a/drivers/clk/ti/clk-44xx.c
+++ b/drivers/clk/ti/clk-44xx.c
@@ -12,7 +12,7 @@
 
 #include <linux/kernel.h>
 #include <linux/list.h>
-#include <linux/clk-private.h>
+#include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 #include <linux/clk/ti.h>
 
diff --git a/drivers/clk/ti/clk-54xx.c b/drivers/clk/ti/clk-54xx.c
index 5e18399..19c4fac 100644
--- a/drivers/clk/ti/clk-54xx.c
+++ b/drivers/clk/ti/clk-54xx.c
@@ -12,7 +12,7 @@
 
 #include <linux/kernel.h>
 #include <linux/list.h>
-#include <linux/clk-private.h>
+#include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 #include <linux/io.h>
 #include <linux/clk/ti.h>
diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
index 62ac8f6..853d9ae 100644
--- a/drivers/clk/ti/clk-7xx.c
+++ b/drivers/clk/ti/clk-7xx.c
@@ -12,7 +12,7 @@
 
 #include <linux/kernel.h>
 #include <linux/list.h>
-#include <linux/clk-private.h>
+#include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 #include <linux/clk/ti.h>
 
-- 
1.9.3

