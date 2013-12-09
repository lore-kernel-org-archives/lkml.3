Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab3LIFa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:30:58 -0500
Received: from top.free-electrons.com ([176.31.233.9]:32868 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750902Ab3LIFaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:30:55 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: liqin.linux@gmail.com, lennox.wu@gmail.com
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] score: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 06:30:48 +0100
Message-Id: <1386567048-19855-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381550982-6029-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381550982-6029-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/score/kernel/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/score/kernel/time.c b/arch/score/kernel/time.c
index f0a43affb201..24770cd9b473 100644
--- a/arch/score/kernel/time.c
+++ b/arch/score/kernel/time.c
@@ -41,7 +41,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction timer_irq = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_TIMER,
+	.flags = IRQF_TIMER,
 	.name = "timer",
 };
 
-- 
1.8.3.2

