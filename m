Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbaBCVnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:43:00 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:45919 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbaBCVm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:42:58 -0500
X-IronPort-AV: E=Sophos;i="4.95,774,1384329600"; 
   d="scan'208";a="12923353"
From: Markus Mayer <markus.mayer@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
CC: Linux GPIO List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: bcm281xx: Update MODULE_AUTHOR
Date: Mon, 3 Feb 2014 13:43:00 -0800
Message-ID: <1391463780-19840-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Broadcom's upstreaming mailing list address to MODULE_AUTHOR.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 drivers/gpio/gpio-bcm-kona.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index 233d088..f32357e 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2012-2013 Broadcom Corporation
+ * Copyright (C) 2012-2014 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -657,6 +657,6 @@ static struct platform_driver bcm_kona_gpio_driver = {
 
 module_platform_driver(bcm_kona_gpio_driver);
 
-MODULE_AUTHOR("Broadcom");
+MODULE_AUTHOR("Broadcom Corporation <bcm-kernel-feedback-list@broadcom.com>");
 MODULE_DESCRIPTION("Broadcom Kona GPIO Driver");
 MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

