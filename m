Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966564AbaFTKQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:16:33 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:58695 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965500AbaFTKQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:16:30 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mark Brown <broonie@kernel.org>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/5] spi: sh-msiof: Add DMA support
Date: Fri, 20 Jun 2014 12:16:15 +0200
Message-Id: <1403259380-13634-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series refactors the Renesas MSIOF SPI driver and adds DMA
support.

  [1/5] spi: sh-msiof: Add more register documentation
  [2/5] spi: sh-msiof: Extract sh_msiof_spi_{start,stop}() helpers
  [3/5] spi: sh-msiof: Improve transfer error handling
  [4/5] spi: sh-msiof: Refactor sh_msiof_transfer_one()
  [5/5] spi: sh-msiof: Add DMA support

 drivers/spi/spi-sh-msiof.c   | 516 +++++++++++++++++++++++++++++++++++++++----
 include/linux/spi/sh_msiof.h |   2 +
 2 files changed, 469 insertions(+), 49 deletions(-)

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
