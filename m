Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab3L3KUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 05:20:21 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51779 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab3L3KUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 05:20:15 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, tglx@linutronix.de
Cc: axel.lin@ingics.com, ezequiel.garcia@free-electrons.com,
        jg1.han@samsung.com, laurent.pinchart+renesas@ideasonboard.com,
        linus.walleij@linaro.org, maxime.ripard@free-electrons.com,
        michael.opdenacker@free-electrons.com, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 19/20] clocksource: bcm_kona_timer: Remove unused bcm_timer_ids
Date: Mon, 30 Dec 2013 11:19:38 +0100
Message-Id: <1388398779-11222-19-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388398779-11222-1-git-send-email-daniel.lezcano@linaro.org>
References: <52C1479E.80808@linaro.org>
 <1388398779-11222-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

bcm_timer_ids is no longer used after converting to CLOCKSOURCE_OF_DECLARE.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/bcm_kona_timer.c |    6 ------
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
1.7.9.5

