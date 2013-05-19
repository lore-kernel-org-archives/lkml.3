Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab3ESGZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 02:25:54 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48583 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3ESGZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 02:25:53 -0400
Message-ID: <1368944748.3455.10.camel@phoenix>
Subject: [PATCH] gpio: max7300: Fix trivial typo in Kconfig help text
From: Axel Lin <axel.lin@ingics.com>
To: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Date: Sun, 19 May 2013 14:25:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max7301 is controlled through SPI interface which means another driver.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/gpio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 6575d77..4e0884a 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -330,7 +330,7 @@ config GPIO_MAX7300
 	depends on I2C
 	select GPIO_MAX730X
 	help
-	  GPIO driver for Maxim MAX7301 I2C-based GPIO expander.
+	  GPIO driver for Maxim MAX7300 I2C-based GPIO expander.
 
 config GPIO_MAX732X
 	tristate "MAX7319, MAX7320-7327 I2C Port Expanders"
-- 
1.8.1.2



