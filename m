Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab3L3QNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:13:22 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47072 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab3L3QJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:09:43 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: olof@lixom.net, khilman@linaro.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 06/17] ARM: cns3xxx: Remove deprecated IRQF_DISABLED flag
Date: Mon, 30 Dec 2013 17:09:20 +0100
Message-Id: <1388419771-30075-6-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
References: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP and scheduled to be removed

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-cns3xxx/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-cns3xxx/core.c b/arch/arm/mach-cns3xxx/core.c
index e38b279..384dc85 100644
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
1.7.9.5

