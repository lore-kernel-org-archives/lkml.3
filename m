Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3JVR1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:27:22 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:50248 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3JVR1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:27:15 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 0/9] backlight: atmel-pwm-bl: fixes and clean ups
Date: Tue, 22 Oct 2013 19:26:50 +0200
Message-Id: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix a few issues and clean up the atmel-pwm-bl driver
somewhat.

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

