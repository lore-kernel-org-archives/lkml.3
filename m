Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590Ab3LIErM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 23:47:12 -0500
Received: from top.free-electrons.com ([176.31.233.9]:60925 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760562Ab3LIErH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 23:47:07 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: anton@enomsg.org, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] ARM: cns3xxx: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 05:46:56 +0100
Message-Id: <1386564416-18947-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381546874-4777-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381546874-4777-1-git-send-email-michael.opdenacker@free-electrons.com>
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
index e38b279f402c..384dc859e6c6 100644
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
1.8.3.2

