Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaDDH7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:59:35 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:51183 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781AbaDDH7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:59:34 -0400
Message-ID: <1396598372.19661.10.camel@x220>
Subject: [PATCH] [TRIVIAL] gpio: fix comment typos 'CONFIG_GPIO_IRQCHIP'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 04 Apr 2014 09:59:32 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2014 07:59:32.0186 (UTC) FILETIME=[CFECABA0:01CF4FDB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

These two typos were introduced in commit 1425052097b5 ("gpio: add IRQ
chip helpers in gpiolib"), which has just been merged.

 include/linux/gpio/driver.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 1827b43..8652ab7 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -102,7 +102,7 @@ struct gpio_chip {
 
 #ifdef CONFIG_GPIOLIB_IRQCHIP
 	/*
-	 * With CONFIG_GPIO_IRQCHIP we get an irqchip inside the gpiolib
+	 * With CONFIG_GPIOLIB_IRQCHIP we get an irqchip inside the gpiolib
 	 * to handle IRQs for most practical cases.
 	 */
 	struct irq_chip		*irqchip;
@@ -218,7 +218,7 @@ int gpiochip_irqchip_add(struct gpio_chip *gpiochip,
 		irq_flow_handler_t handler,
 		unsigned int type);
 
-#endif /* CONFIG_GPIO_IRQCHIP */
+#endif /* CONFIG_GPIOLIB_IRQCHIP */
 
 #else /* CONFIG_GPIOLIB */
 
-- 
1.9.0

