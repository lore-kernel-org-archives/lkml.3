Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbaIELJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:09:28 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:51236 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756552AbaIELJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:09:27 -0400
Message-ID: <1409915365.7832.14.camel@x220>
Subject: [PATCH] [RESEND] [TRIVIAL] gpio: fix comment typos
 'CONFIG_GPIO_IRQCHIP'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 05 Sep 2014 13:09:25 +0200
In-Reply-To: <1409872723.5546.137.camel@x220>
References: <1396598372.19661.10.camel@x220>
	 <1409872723.5546.137.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Sep 2014 11:09:25.0652 (UTC) FILETIME=[DA931D40:01CFC8F9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Resending at Jiri's request.

Build tested, actually (but only by building drivers/gpio/gpiolib.o).

These two typos were introduced in commit 1425052097b5 ("gpio: add IRQ
chip helpers in gpiolib").

 include/linux/gpio/driver.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index a2de58fffd19..f8f6fae0b7c3 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -105,7 +105,7 @@ struct gpio_chip {
 
 #ifdef CONFIG_GPIOLIB_IRQCHIP
 	/*
-	 * With CONFIG_GPIO_IRQCHIP we get an irqchip inside the gpiolib
+	 * With CONFIG_GPIOLIB_IRQCHIP we get an irqchip inside the gpiolib
 	 * to handle IRQs for most practical cases.
 	 */
 	struct irq_chip		*irqchip;
@@ -164,7 +164,7 @@ int gpiochip_irqchip_add(struct gpio_chip *gpiochip,
 		irq_flow_handler_t handler,
 		unsigned int type);
 
-#endif /* CONFIG_GPIO_IRQCHIP */
+#endif /* CONFIG_GPIOLIB_IRQCHIP */
 
 struct gpio_desc *gpiochip_request_own_desc(struct gpio_chip *chip, u16 hwnum,
 					    const char *label);
-- 
1.9.3

