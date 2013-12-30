Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab3L3QKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:10:00 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59866 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3L3QJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:09:56 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: olof@lixom.net, khilman@linaro.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 14/17] ARM: netx: Remove deprecated IRQF_DISABLED flag
Date: Mon, 30 Dec 2013 17:09:28 +0100
Message-Id: <1388419771-30075-14-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
References: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP and scheduled to be removed

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-netx/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-netx/time.c b/arch/arm/mach-netx/time.c
index 6df42e6..3177c7a 100644
--- a/arch/arm/mach-netx/time.c
+++ b/arch/arm/mach-netx/time.c
@@ -99,7 +99,7 @@ netx_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction netx_timer_irq = {
 	.name		= "NetX Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= netx_timer_interrupt,
 };
 
-- 
1.7.9.5

