Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3JLDlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 23:41:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53909 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754665Ab3JLDlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 23:41:02 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: viresh.linux@gmail.com, shiraz.hashim@st.com, linux@arm.linux.org.uk
Cc: spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: spear: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 05:40:56 +0200
Message-Id: <1381549256-5301-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-spear/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-spear/time.c b/arch/arm/mach-spear/time.c
index d449673..218ba5b 100644
--- a/arch/arm/mach-spear/time.c
+++ b/arch/arm/mach-spear/time.c
@@ -172,7 +172,7 @@ static irqreturn_t spear_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction spear_timer_irq = {
 	.name = "timer",
-	.flags = IRQF_DISABLED | IRQF_TIMER,
+	.flags = IRQF_TIMER,
 	.handler = spear_timer_interrupt
 };
 
-- 
1.8.1.2

