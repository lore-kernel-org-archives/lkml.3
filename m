Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbaDLBc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 21:32:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:55530 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbaDLBcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 21:32:54 -0400
From: Steven Miao <realmz6@kernel.org>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: adi-buildroot-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Steven Miao <realmz6@gmail.com>
Subject: [PATCH] video: bf54x-lq043fb: fix build error
Date: Sat, 12 Apr 2014 09:30:45 +0800
Message-Id: <1397266245-3144-1-git-send-email-realmz6@kernel.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Miao <realmz6@gmail.com>

should include linux/gpio.h

Signed-off-by: Steven Miao <realmz6@gmail.com>
---
 drivers/video/bf54x-lq043fb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index 42b8f9d..d2b54f1 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -49,6 +49,7 @@
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
+#include <linux/gpio.h>
 
 #include <asm/blackfin.h>
 #include <asm/irq.h>
-- 
1.7.9.5

