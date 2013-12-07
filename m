Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab3LGNJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 08:09:43 -0500
Received: from top.free-electrons.com ([176.31.233.9]:57579 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755388Ab3LGNJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 08:09:09 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/3] pinctrl: at91: correct a few typos
Date: Sat,  7 Dec 2013 14:08:52 +0100
Message-Id: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/pinctrl/pinctrl-at91.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index a7549c4c83b4..6446dc804aa7 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -118,7 +118,7 @@ struct at91_pin_group {
 };
 
 /**
- * struct at91_pinctrl_mux_ops - describes an At91 mux ops group
+ * struct at91_pinctrl_mux_ops - describes an AT91 mux ops group
  * on new IP with support for periph C and D the way to mux in
  * periph A and B has changed
  * So provide the right call back
@@ -1396,7 +1396,7 @@ static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 	chained_irq_enter(chip, desc);
 	for (;;) {
 		/* Reading ISR acks pending (edge triggered) GPIO interrupts.
-		 * When there none are pending, we're finished unless we need
+		 * When there are none pending, we're finished unless we need
 		 * to process multiple banks (like ID_PIOCDE on sam9263).
 		 */
 		isr = readl_relaxed(pio + PIO_ISR) & readl_relaxed(pio + PIO_IMR);
@@ -1505,7 +1505,7 @@ static int at91_gpio_of_irq_setup(struct device_node *node,
 		prev = gpio_chips[at91_gpio->pioc_idx - 1];
 
 	/* The top level handler handles one bank of GPIOs, except
-	 * on some SoC it can handles up to three...
+	 * on some SoC it can handle up to three...
 	 * We only set up the handler for the first of the list.
 	 */
 	if (prev && prev->next == at91_gpio)
-- 
1.8.3.2

