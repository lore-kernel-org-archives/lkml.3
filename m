Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3JaR7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 13:59:30 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:40473 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab3JaR6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:58:21 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 0/9] backlight: atmel-pwm-bl: fixes and clean ups
Date: Thu, 31 Oct 2013 18:57:35 +0100
Message-Id: <1383242264-7652-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383064064-4983-1-git-send-email-jhovold@gmail.com>
References: <1383064064-4983-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix a few issues and clean up the atmel-pwm-bl driver
somewhat.

Acks from Jingoo Han retained on all patches but the slightly modified
first and final patch.

Johan

v2:
 - mask returned brightness rather than cast it to u16 (patch 1/9)
v3
 - use unsigned long for gpio flags (patch 9/9)

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
1.8.4.2

