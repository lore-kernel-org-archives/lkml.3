Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3JLDBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 23:01:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53795 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752395Ab3JLDBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 23:01:17 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: anton@enomsg.org, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: cns3xxx: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 05:01:14 +0200
Message-Id: <1381546874-4777-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-cns3xxx/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-cns3xxx/core.c b/arch/arm/mach-cns3xxx/core.c
index e38b279..384dc85 100644
--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -155,7 +155,7 @@ static irqreturn_t cns3xxx_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction cns3xxx_timer_irq = {
 	.name		= "timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= cns3xxx_timer_interrupt,
 };
 
-- 
1.8.1.2

