Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab3GZOD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:03:56 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:53622 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab3GZODy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:03:54 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, john.stultz@linaro.org,
        tglx@linutronix.de, u.kleine-koenig@pengutronix.de,
        tomasz.figa@gmail.com, linus.walleij@linaro.org,
        thomas.petazzoni@free-electrons.com, arnd@arndb.de,
        daniel.lezcano@linaro.org, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] ARM: clocksource: moxart: add bitops.h include
Date: Fri, 26 Jul 2013 16:03:38 +0200
Message-Id: <1374847418-21436-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <51EB0265.2030508@linaro.org>
References: <51EB0265.2030508@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bitops.h included implicitly, add #include <linux/bitops.h>

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Hi Daniel,
    
    A separate patch for moxart clocksource (already merged), as you requested.
    
    Can be applied directly to timers/clockevents-next.
    
    Best regards,
    Jonas

 drivers/clocksource/moxart_timer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/moxart_timer.c b/drivers/clocksource/moxart_timer.c
index 08a5943..5eb2c35 100644
--- a/drivers/clocksource/moxart_timer.c
+++ b/drivers/clocksource/moxart_timer.c
@@ -20,6 +20,7 @@
 #include <linux/of_irq.h>
 #include <linux/io.h>
 #include <linux/clocksource.h>
+#include <linux/bitops.h>
 
 #define TIMER1_BASE		0x00
 #define TIMER2_BASE		0x10
-- 
1.8.2.1

