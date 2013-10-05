Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab3JEEGN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 00:06:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49326 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750846Ab3JEEGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 00:06:12 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: ulli.kroll@googlemail.com, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: gemini: remove obsolete IRQF_DISABLED
Date: Sat,  5 Oct 2013 06:06:04 +0200
Message-Id: <1380945964-3086-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-gemini/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-gemini/time.c b/arch/arm/mach-gemini/time.c
index 21dc5a8..cc996ec 100644
--- a/arch/arm/mach-gemini/time.c
+++ b/arch/arm/mach-gemini/time.c
@@ -45,7 +45,7 @@ static irqreturn_t gemini_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction gemini_timer_irq = {
 	.name		= "Gemini Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 	.handler	= gemini_timer_interrupt,
 };
 
-- 
1.8.1.2

