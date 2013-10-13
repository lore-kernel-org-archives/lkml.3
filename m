Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3JMG0h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 02:26:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56283 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752670Ab3JMG0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 02:26:35 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: samuel@sortiz.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] irda: update comment mentioning IRQF_DISABLED
Date: Sun, 13 Oct 2013 08:26:31 +0200
Message-Id: <1381645591-9565-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a comment mentioning IRQF_DISABLED,
which is deprecated.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 include/net/irda/irda_device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/irda/irda_device.h b/include/net/irda/irda_device.h
index 94c852d..1141747 100644
--- a/include/net/irda/irda_device.h
+++ b/include/net/irda/irda_device.h
@@ -162,7 +162,7 @@ typedef struct {
         int irq, irq2;        /* Interrupts used */
         int dma, dma2;        /* DMA channel(s) used */
         int fifo_size;        /* FIFO size */
-        int irqflags;         /* interrupt flags (ie, IRQF_SHARED|IRQF_DISABLED) */
+        int irqflags;         /* interrupt flags (ie, IRQF_SHARED) */
 	int direction;        /* Link direction, used by some FIR drivers */
 	int enabled;          /* Powered on? */
 	int suspended;        /* Suspended by APM */
-- 
1.8.1.2

