Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbaDOHRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:17:33 -0400
Received: from mail.kernel.org ([198.145.19.201]:37102 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaDOHRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:17:31 -0400
From: Steven Miao <realmz6@kernel.org>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: adi-buildroot-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Steven Miao <realmz6@gmail.com>
Subject: [PATCH RESEND] video: bf54x-lq043fb: fix build error
Date: Tue, 15 Apr 2014 15:17:19 +0800
Message-Id: <1397546239-6650-1-git-send-email-realmz6@kernel.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Miao <realmz6@gmail.com>

include <linux/gpio.h>, drop <asm/gpio.h>

Signed-off-by: Steven Miao <realmz6@gmail.com>
---
 drivers/video/bf54x-lq043fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index 42b8f9d..e2c42ad 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -49,13 +49,13 @@
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
+#include <linux/gpio.h>
 
 #include <asm/blackfin.h>
 #include <asm/irq.h>
 #include <asm/dpmc.h>
 #include <asm/dma-mapping.h>
 #include <asm/dma.h>
-#include <asm/gpio.h>
 #include <asm/portmux.h>
 
 #include <mach/bf54x-lq043.h>
-- 
1.7.9.5

