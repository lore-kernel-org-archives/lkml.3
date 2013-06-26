Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3FZVRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:17:12 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51799 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab3FZVRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:17:04 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/8] clocksource: sun4i: Use the BIT macros where possible
Date: Wed, 26 Jun 2013 23:16:54 +0200
Message-Id: <1372281421-2099-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index d4674e7..bdf34d9 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -24,12 +24,12 @@
 #include <linux/of_irq.h>
 
 #define TIMER_IRQ_EN_REG	0x00
-#define TIMER_IRQ_EN(val)		(1 << val)
+#define TIMER_IRQ_EN(val)		BIT(val)
 #define TIMER_IRQ_ST_REG	0x04
 #define TIMER_CTL_REG(val)	(0x10 * val + 0x10)
-#define TIMER_CTL_ENABLE		(1 << 0)
-#define TIMER_CTL_AUTORELOAD		(1 << 1)
-#define TIMER_CTL_ONESHOT		(1 << 7)
+#define TIMER_CTL_ENABLE		BIT(0)
+#define TIMER_CTL_AUTORELOAD		BIT(1)
+#define TIMER_CTL_ONESHOT		BIT(7)
 #define TIMER_INTVAL_REG(val)	(0x10 * val + 0x14)
 #define TIMER_CNTVAL_REG(val)	(0x10 * val + 0x18)
 
-- 
1.8.3.1

