Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaBYKZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:25:00 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:41276 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaBYKVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:21:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] spi: sh-msiof: Add support for R-Car H2 and M2
Date: Tue, 25 Feb 2014 11:21:07 +0100
Message-Id: <1393323673-2751-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        Hi Mark,

This patch series refactors the sh-msiof SPI driver and adds support for
the MSIOF variant in the Renesas R-Car H2 (r8a7790) and M2 (r8a7791) SoCs.

It was tested on the Lager and Koelsch development boards, using a dummy
driver for the Renesas r2a11302ft PMIC that reads out the PMIC's version ID.

    [1/6] spi: sh-msiof: Improve bindings
    [2/6] spi: sh-msiof: Move default FIFO sizes to device ID data
    [3/6] spi: sh-msiof: Add support for R-Car H2 and M2
    [4/6] spi: sh-msiof: Move clock management to (un)prepare_message()
    [5/6] spi: sh-msiof: Convert to let spi core validate xfer->bits_per_word
    [6/6] spi: sh-msiof: Use core message handling instead of spi-bitbang

These are (reworked versions of) the remaining patches not taken from v1.
Changelogs are available in the individual patches.

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
