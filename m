Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab3L3QJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:09:49 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:42491 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3L3QJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:09:46 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: olof@lixom.net, khilman@linaro.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 08/17] ARM: ks8695: Remove deprecated IRQF_DISABLED flag
Date: Mon, 30 Dec 2013 17:09:22 +0100
Message-Id: <1388419771-30075-8-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
References: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP and scheduled to be removed

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-ks8695/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ks8695/time.c b/arch/arm/mach-ks8695/time.c
index 426c976..a197874 100644
--- a/arch/arm/mach-ks8695/time.c
+++ b/arch/arm/mach-ks8695/time.c
@@ -122,7 +122,7 @@ static irqreturn_t ks8695_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction ks8695_timer_irq = {
 	.name		= "ks8695_tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 	.handler	= ks8695_timer_interrupt,
 };
 
-- 
1.7.9.5

