Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab3GJLzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:55:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:18096 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469Ab3GJLzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:55:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1035,1363158000"; 
   d="scan'208";a="343302186"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/5] pinctrl-baytrail: fix indentations
Date: Wed, 10 Jul 2013 14:55:36 +0300
Message-Id: <1373457340-16666-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two minor issues with indentation in the code. This patch fixes them.
No functional changes.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/pinctrl/Kconfig            | 2 +-
 drivers/pinctrl/pinctrl-baytrail.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 5a8ad51..bc830af 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -61,7 +61,7 @@ config PINCTRL_AT91
 config PINCTRL_BAYTRAIL
 	bool "Intel Baytrail GPIO pin control"
 	depends on GPIOLIB && ACPI && X86
-        select IRQ_DOMAIN
+	select IRQ_DOMAIN
 	help
 	  driver for memory mapped GPIO functionality on Intel Baytrail
 	  platforms. Supports 3 banks with 102, 28 and 44 gpios.
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index e9d735d..fccf72e 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -516,6 +516,7 @@ static int byt_gpio_remove(struct platform_device *pdev)
 {
 	struct byt_gpio *vg = platform_get_drvdata(pdev);
 	int err;
+
 	pm_runtime_disable(&pdev->dev);
 	err = gpiochip_remove(&vg->chip);
 	if (err)
-- 
1.8.3.2

