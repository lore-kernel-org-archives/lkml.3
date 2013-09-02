Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3IBCGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 22:06:21 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57811 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3IBCGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:06:20 -0400
From: Fabio Estevam <festevam@gmail.com>
To: tglx@linutronix.de
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] irqchip: irq-mxs: Include <linux/irqchip/mxs.h>
Date: Sun,  1 Sep 2013 23:06:08 -0300
Message-Id: <1378087568-22537-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Include <linux/irqchip/mxs.h> in order to fix the following sparse warning:

drivers/irqchip/irq-mxs.c:75:39: warning: symbol 'icoll_handle_irq' was not declared. Should it be static?

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/irqchip/irq-mxs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-mxs.c b/drivers/irqchip/irq-mxs.c
index 63b3d4e..4269f22 100644
--- a/drivers/irqchip/irq-mxs.c
+++ b/drivers/irqchip/irq-mxs.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/irq.h>
+#include <linux/irqchip/mxs.h>
 #include <linux/irqdomain.h>
 #include <linux/io.h>
 #include <linux/of.h>
-- 
1.8.1.2

