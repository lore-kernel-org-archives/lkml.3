Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3FDPrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:47:05 -0400
Received: from sauhun.de ([89.238.76.85]:39165 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab3FDPrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:47:03 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] gpio: devres: make comments proper
Date: Tue,  4 Jun 2013 17:48:36 +0200
Message-Id: <1370360926-3695-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The free-function mentioned "interrupt" instead of "GPIO". While we are
here, use "GPIO" (capital letters) consistently.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/gpio/devres.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 1077754..3e7812f 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -34,10 +34,10 @@ static int devm_gpio_match(struct device *dev, void *res, void *data)
 }
 
 /**
- *      devm_gpio_request - request a gpio for a managed device
- *      @dev: device to request the gpio for
- *      @gpio: gpio to allocate
- *      @label: the name of the requested gpio
+ *      devm_gpio_request - request a GPIO for a managed device
+ *      @dev: device to request the GPIO for
+ *      @gpio: GPIO to allocate
+ *      @label: the name of the requested GPIO
  *
  *      Except for the extra @dev argument, this function takes the
  *      same arguments and performs the same function as
@@ -101,9 +101,9 @@ int devm_gpio_request_one(struct device *dev, unsigned gpio,
 EXPORT_SYMBOL(devm_gpio_request_one);
 
 /**
- *      devm_gpio_free - free an interrupt
- *      @dev: device to free gpio for
- *      @gpio: gpio to free
+ *      devm_gpio_free - free a GPIO
+ *      @dev: device to free GPIO for
+ *      @gpio: GPIO to free
  *
  *      Except for the extra @dev argument, this function takes the
  *      same arguments and performs the same function as gpio_free().
-- 
1.7.10.4

