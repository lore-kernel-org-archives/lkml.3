Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab3DQQf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:35:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab3DQQf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:35:28 -0400
Subject: [PATCH] gpio: ucb1400: Can be built as a module
From: Jean Delvare <jdelvare@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Marek Vasut <marex@denx.de>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Wed, 17 Apr 2013 18:34:34 +0200
Message-ID: <1366216474.8215.1.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent code cleanup from Marek Vasut, driver gpio-ucb1400 can
be built as a module, so change symbol GPIO_UCB1400 from bool to
tristate.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Marek Vasut <marex@denx.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.9-rc7.orig/drivers/gpio/Kconfig	2013-03-05 10:33:27.814889286 +0100
+++ linux-3.9-rc7/drivers/gpio/Kconfig	2013-04-17 18:24:33.732960538 +0200
@@ -652,7 +652,7 @@ config GPIO_74X164
 comment "AC97 GPIO expanders:"
 
 config GPIO_UCB1400
-	bool "Philips UCB1400 GPIO"
+	tristate "Philips UCB1400 GPIO"
 	depends on UCB1400_CORE
 	help
 	  This enables support for the Philips UCB1400 GPIO pins.

-- 
Jean Delvare
Suse L3

