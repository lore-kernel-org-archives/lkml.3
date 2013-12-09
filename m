Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab3LIFKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:10:21 -0500
Received: from top.free-electrons.com ([176.31.233.9]:32805 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750821Ab3LIFKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:10:19 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: mcuos.com@gmail.com, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] ARM: w90x900: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 06:10:10 +0100
Message-Id: <1386565810-19467-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <CAKT61h8QGU0ZZhms9WgMmyWhEmB_odTOfD0guihf6TfRpZ2YUw@mail.gmail.com>
References: <CAKT61h8QGU0ZZhms9WgMmyWhEmB_odTOfD0guihf6TfRpZ2YUw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Acked-by: Wan zongshun <mcuos.com@gmail.com>
---
 arch/arm/mach-w90x900/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-w90x900/time.c b/arch/arm/mach-w90x900/time.c
index 30fbca844575..9230d3725599 100644
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
1.8.3.2

