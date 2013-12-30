Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab3L3QNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:13:52 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48416 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab3L3QJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:09:37 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: olof@lixom.net, khilman@linaro.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 03/17] ARM: sa1100: Remove deprecated IRQF_DISABLED flag
Date: Mon, 30 Dec 2013 17:09:17 +0100
Message-Id: <1388419771-30075-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
References: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP and scheduled to be removed

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-sa1100/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-sa1100/time.c b/arch/arm/mach-sa1100/time.c
index 6fd4acb..4852c08 100644
--- a/arch/arm/mach-sa1100/time.c
+++ b/arch/arm/mach-sa1100/time.c
@@ -112,7 +112,7 @@ static struct clock_event_device ckevt_sa1100_osmr0 = {
 
 static struct irqaction sa1100_timer_irq = {
 	.name		= "ost0",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= sa1100_ost0_interrupt,
 	.dev_id		= &ckevt_sa1100_osmr0,
 };
-- 
1.7.9.5

