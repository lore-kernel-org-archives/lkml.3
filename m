Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbaDLBZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 21:25:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:55308 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060AbaDLBZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 21:25:52 -0400
From: Steven Miao <realmz6@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: adi-buildroot-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Steven Miao <realmz6@gmail.com>
Subject: [PATCH] spi: bfin5xx: fix build error
Date: Sat, 12 Apr 2014 09:23:24 +0800
Message-Id: <1397265804-3018-1-git-send-email-realmz6@kernel.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Miao <realmz6@gmail.com>

should include linux/gpio.h

Signed-off-by: Steven Miao <realmz6@gmail.com>
---
 drivers/spi/spi-bfin5xx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-bfin5xx.c b/drivers/spi/spi-bfin5xx.c
index 55e57c3..ebf720b 100644
--- a/drivers/spi/spi-bfin5xx.c
+++ b/drivers/spi/spi-bfin5xx.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/gpio.h>
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
-- 
1.7.9.5

