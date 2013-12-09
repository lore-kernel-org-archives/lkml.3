Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab3LIFHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:07:11 -0500
Received: from top.free-electrons.com ([176.31.233.9]:32789 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750724Ab3LIFHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:07:09 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: viresh.linux@gmail.com, shiraz.hashim@st.com, linux@arm.linux.org.uk
Cc: spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] ARM: spear: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 06:06:59 +0100
Message-Id: <1386565619-19355-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381549256-5301-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381549256-5301-1-git-send-email-michael.opdenacker@free-electrons.com>
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
index d449673e40f7..218ba5b67d92 100644
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
1.8.3.2

