Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3JVR1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:27:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52325 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3JVR1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:27:14 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3/9] backlight: atmel-pwm-bl: fix module autoload
Date: Tue, 22 Oct 2013 19:26:53 +0200
Message-Id: <1382462819-28576-4-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing module alias which is needed for module autoloading.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/video/backlight/atmel-pwm-bl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 3cb0094..cc5a5ed 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -229,3 +229,4 @@ module_platform_driver(atmel_pwm_bl_driver);
 MODULE_AUTHOR("Hans-Christian egtvedt <hans-christian.egtvedt@atmel.com>");
 MODULE_DESCRIPTION("Atmel PWM backlight driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:atmel-pwm-bl");
-- 
1.8.4

