Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbbAZLEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:04:24 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42091 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbAZLEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:04:21 -0500
From: Johan Hovold <johan@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 0/2] gpio: sysfs: fix memory leaks
Date: Mon, 26 Jan 2015 12:02:44 +0100
Message-Id: <1422270166-17525-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two more fixes for long-standing memory leaks in the gpio sysfs
interface (for v3.19).

Johan


Johan Hovold (2):
  gpio: sysfs: fix memory leak in gpiod_export_link
  gpio: sysfs: fix memory leak in gpiod_sysfs_set_active_low

 drivers/gpio/gpiolib-sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.0.5

