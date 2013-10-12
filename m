Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3JLDo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 23:44:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53941 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751890Ab3JLDoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 23:44:25 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: mcuos.com@gmail.com, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: w90x900: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 05:44:11 +0200
Message-Id: <1381549451-5362-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-w90x900/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-w90x900/time.c b/arch/arm/mach-w90x900/time.c
index 30fbca8..9230d37 100644
--- a/arch/arm/mach-w90x900/time.c
+++ b/arch/arm/mach-w90x900/time.c
@@ -111,7 +111,7 @@ static irqreturn_t nuc900_timer0_interrupt(int irq, void *dev_id)
 
 static struct irqaction nuc900_timer0_irq = {
 	.name		= "nuc900-timer0",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= nuc900_timer0_interrupt,
 };
 
-- 
1.8.1.2

