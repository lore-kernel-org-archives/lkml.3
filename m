Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab3KFD2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 22:28:05 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:47488 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab3KFD2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 22:28:03 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org
Subject: [PATCH] gpio: pl061: don't depend on CONFIG_ARM
Date: Tue,  5 Nov 2013 21:27:02 -0600
Message-Id: <1383708422-20374-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The pl061 driver has no real dependency on ARM, so remove the kconfig
dependency.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org
---
 drivers/gpio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index a0471e6..0f04444 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -213,7 +213,7 @@ config GPIO_OCTEON
 
 config GPIO_PL061
 	bool "PrimeCell PL061 GPIO support"
-	depends on ARM && ARM_AMBA
+	depends on ARM_AMBA
 	select GENERIC_IRQ_CHIP
 	help
 	  Say yes here to support the PrimeCell PL061 GPIO device
-- 
1.8.1.2

