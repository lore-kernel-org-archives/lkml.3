Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbbALKIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:08:04 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:57236 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbbALKIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:08:02 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-gpio@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/2] gpio: rcar: Convert to use gpiolib irqchip
Date: Mon, 12 Jan 2015 11:07:57 +0100
Message-Id: <1421057279-16081-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus, Alexandre,

This patch series converts the Renesas R-Car Gen2 GPIO driver to use the
gpiolib irqchip helpers.

It was tested on r8a7791/koelsch.

Thanks!

Geert Uytterhoeven (2):
  gpio: rcar: Fix error path for devm_kzalloc() failure
  gpio: rcar: Switch to use gpiolib irqchip helpers

 drivers/gpio/Kconfig     |  1 +
 drivers/gpio/gpio-rcar.c | 75 ++++++++++++++++--------------------------------
 2 files changed, 26 insertions(+), 50 deletions(-)

-- 
1.9.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
