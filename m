Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbaFPO7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:59:00 -0400
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:33785 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699AbaFPO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:58:57 -0400
X-RRZE-Submit-IP: 131.188.42.190
From: Stephan Gabert <stephan.gabert@fau.de>
To: pe1dnn@amsat.org, gregkh@linuxfoundation.org
Cc: nicolas.pfeiffer@fau.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        Stephan Gabert <stephan.gabert@fau.de>
Subject: [PATCH 1/5] staging/wlags49_h2: checkpatch: including <linux/*.h> instead of <asm/*.h>
Date: Mon, 16 Jun 2014 16:50:49 +0200
Message-Id: <1402930253-32537-2-git-send-email-stephan.gabert@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402930253-32537-1-git-send-email-stephan.gabert@fau.de>
References: <1402930253-32537-1-git-send-email-stephan.gabert@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As warned by checkpatch.pl, one should use #include <linux/io.h>
instead of #include <asm/io.h> and #include <linux/bitops.h>
instead of #include <asm/bitops.h>.

Signed-off-by: Stephan Gabert <stephan.gabert@fau.de>
Signed-off-by: Nicolas Pfeiffer <nicolas.pfeiffer@fau.de>
---
 drivers/staging/wlags49_h2/wl_cs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index 3f7cf41..5c6e18c 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -73,8 +73,8 @@
 #include <linux/interrupt.h>
 #include <linux/in.h>
 #include <linux/delay.h>
-#include <asm/io.h>
-#include <asm/bitops.h>
+#include <linux/io.h>
+#include <linux/bitops.h>
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-- 
1.9.1

