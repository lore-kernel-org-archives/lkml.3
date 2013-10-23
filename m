Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3JWJ5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:57:47 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:52078 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab3JWJ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:56:01 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH RESEND 0/9] backlight: atmel-pwm-bl: fixes and clean ups
Date: Wed, 23 Oct 2013 11:55:34 +0200
Message-Id: <1382522143-32072-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix a few issues and clean up the atmel-pwm-bl driver
somewhat.

Resend with added ack from Jingo Han.

Johan

Johan Hovold (9):
  backlight: atmel-pwm-bl: fix reported brightness
  backlight: atmel-pwm-bl: fix gpio polarity in remove
  backlight: atmel-pwm-bl: fix module autoload
  backlight: atmel-pwm-bl: clean up probe error handling
  backlight: atmel-pwm-bl: clean up get_intensity
  backlight: atmel-pwm-bl: remove unused include
  backlight: atmel-pwm-bl: use gpio_is_valid
  backlight: atmel-pwm-bl: refactor gpio_on handling
  backlight: atmel-pwm-bl: use gpio_request_one

 drivers/video/backlight/atmel-pwm-bl.c | 86 ++++++++++++++++------------------
 1 file changed, 40 insertions(+), 46 deletions(-)

-- 
1.8.4

