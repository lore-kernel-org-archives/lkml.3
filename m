Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab3JLDtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 23:49:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53958 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753313Ab3JLDtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 23:49:24 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: jason@lakedaemon.net, andrew@lunn.ch, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] arm: plat-orion: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 05:49:20 +0200
Message-Id: <1381549760-5432-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/plat-orion/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-orion/time.c b/arch/arm/plat-orion/time.c
index 9d2b2ac..df671d0 100644
--- a/arch/arm/plat-orion/time.c
+++ b/arch/arm/plat-orion/time.c
@@ -174,7 +174,7 @@ static irqreturn_t orion_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction orion_timer_irq = {
 	.name		= "orion_tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 	.handler	= orion_timer_interrupt
 };
 
-- 
1.8.1.2

