Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3JLDZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 23:25:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53873 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752735Ab3JLDZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 23:25:05 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: eric.y.miao@gmail.com, haojian.zhuang@gmail.com, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: mmp: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 05:24:59 +0200
Message-Id: <1381548299-5093-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-mmp/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
index 7ac41e8..6aacc9b 100644
--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -186,7 +186,7 @@ static void __init timer_config(void)
 
 static struct irqaction timer_irq = {
 	.name		= "timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= timer_interrupt,
 	.dev_id		= &ckevt,
 };
-- 
1.8.1.2

