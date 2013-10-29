Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab3J2Q2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:28:21 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:51568 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab3J2Q2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:28:13 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v2 6/9] backlight: atmel-pwm-bl: remove unused include
Date: Tue, 29 Oct 2013 17:27:41 +0100
Message-Id: <1383064064-4983-7-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383064064-4983-1-git-send-email-jhovold@gmail.com>
References: <1382522143-32072-1-git-send-email-jhovold@gmail.com>
 <1383064064-4983-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused include of clk.h.

Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/video/backlight/atmel-pwm-bl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index abfaada..bfd6a96 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/fb.h>
-#include <linux/clk.h>
 #include <linux/gpio.h>
 #include <linux/backlight.h>
 #include <linux/atmel_pwm.h>
-- 
1.8.4.2

