Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaBTOqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:46:42 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:47701 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaBTOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:43:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/10] spi: sh-msiof: Add support for R-Car H2 and M2
Date: Thu, 20 Feb 2014 15:42:59 +0100
Message-Id: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Mark,

This patch series refactors the sh-msiof SPI driver and adds support for
the MSIOF variant in the Renesas R-Car H2 (r8a7790) and M2 (r8a7791) SoCs.

It was tested on the Lager and Koelsch development boards, using a dummy
driver for the Renesas r2a11302ft PMIC that reads out the PMIC's version ID.

  [01/10] spi: sh-msiof: Fix SPI bus population from DT
  [02/10] spi: sh-msiof: Typo in comment s/tx/rx/
  [03/10] spi: sh-msiof: Change hz from unsigned long to u32
  [04/10] spi: sh-msiof: Add more register documentation
  [05/10] spi: sh-msiof: Use the core cs_gpio field, and make it optional
  [06/10] spi: sh-msiof: Improve binding documentation
  [07/10] spi: sh-msiof: Add support for R-Car H2 and M2
  [08/10] spi: sh-msiof: Move clock management to (un)prepare_message()
  [09/10] spi: sh-msiof: Convert to let spi core validate xfer->bits_per_word
  [10/10] spi: sh-msiof: Use core message handling instead of spi-bitbang

Some of this work was based on a patch series by Takashi Yoshii
<takasi-y@ops.dti.ne.jp>.

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
