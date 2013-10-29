Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab3J2Q2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:28:17 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:55620 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3J2Q2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:28:12 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v2 3/9] backlight: atmel-pwm-bl: fix module autoload
Date: Tue, 29 Oct 2013 17:27:38 +0100
Message-Id: <1383064064-4983-4-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383064064-4983-1-git-send-email-jhovold@gmail.com>
References: <1382522143-32072-1-git-send-email-jhovold@gmail.com>
 <1383064064-4983-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing module alias which is needed for module autoloading.

Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/video/backlight/atmel-pwm-bl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index e21beb6..4886028 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -229,3 +229,4 @@ module_platform_driver(atmel_pwm_bl_driver);
 MODULE_AUTHOR("Hans-Christian egtvedt <hans-christian.egtvedt@atmel.com>");
 MODULE_DESCRIPTION("Atmel PWM backlight driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:atmel-pwm-bl");
-- 
1.8.4.2

