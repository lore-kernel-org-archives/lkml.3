Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaKQJZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:25:22 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:15538 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636AbaKQJZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:25:18 -0500
From: Qiang Chen <qiang2.chen@sonymobile.com>
To: <tomi.valkeinen@ti.com>, <plagnioj@jcrosoft.com>, <linux@arm.linux.org.uk>,
        <pawel.moll@arm.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <qcwj.lk@gmail.com>
Subject: [PATCH] video: ARM CLCD: Remove duplicated include in amba-clcd.c
Date: Mon, 17 Nov 2014 17:25:01 +0800
Message-ID: <1416216301-15854-1-git-send-email-qiang2.chen@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes duplicated include dma-mapping.h in
drivers/video/fbdev/amba-clcd.c

Signed-off-by: Qiang Chen <qiang2.chen@sonymobile.com>
---
 drivers/video/fbdev/amba-clcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/fbdev/amba-clcd.c b/drivers/video/fbdev/amba-clcd.c
index 6ad23bd..32c0b6b 100644
--- a/drivers/video/fbdev/amba-clcd.c
+++ b/drivers/video/fbdev/amba-clcd.c
@@ -27,7 +27,6 @@
 #include <linux/bitops.h>
 #include <linux/clk.h>
 #include <linux/hardirq.h>
-#include <linux/dma-mapping.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_graph.h>
-- 
1.8.2.2

