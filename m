Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab3KYBy4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 20:54:56 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50180 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab3KYByx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 20:54:53 -0500
Message-ID: <1385344485.2241.2.camel@phoenix>
Subject: [PATCH] clocksource: bcm_kona_timer: Remove unused bcm_timer_ids
From: Axel Lin <axel.lin@ingics.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Christian Daudt <bcm@fixthebug.org>, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org
Date: Mon, 25 Nov 2013 09:54:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_timer_ids is no longer used after converting to CLOCKSOURCE_OF_DECLARE.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/clocksource/bcm_kona_timer.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
index 0d7d8c3..5176e76 100644
--- a/drivers/clocksource/bcm_kona_timer.c
+++ b/drivers/clocksource/bcm_kona_timer.c
@@ -98,12 +98,6 @@ kona_timer_get_counter(void *timer_base, uint32_t *msw, uint32_t *lsw)
 	return;
 }
 
-static const struct of_device_id bcm_timer_ids[] __initconst = {
-	{.compatible = "brcm,kona-timer"},
-	{.compatible = "bcm,kona-timer"}, /* deprecated name */
-	{},
-};
-
 static void __init kona_timers_init(struct device_node *node)
 {
 	u32 freq;
-- 
1.8.1.2



