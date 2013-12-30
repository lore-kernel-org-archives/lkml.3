Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab3L3QLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:11:54 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:50580 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab3L3QJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:09:52 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: olof@lixom.net, khilman@linaro.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/17] ARM: iop: Remove deprecated IRQF_DISABLED flag
Date: Mon, 30 Dec 2013 17:09:25 +0100
Message-Id: <1388419771-30075-11-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
References: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP and scheduled to be removed

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/plat-iop/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
index d70b733..6ad65d8 100644
--- a/arch/arm/plat-iop/time.c
+++ b/arch/arm/plat-iop/time.c
@@ -127,7 +127,7 @@ iop_timer_interrupt(int irq, void *dev_id)
 static struct irqaction iop_timer_irq = {
 	.name		= "IOP Timer Tick",
 	.handler	= iop_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.dev_id		= &iop_clockevent,
 };
 
-- 
1.7.9.5

