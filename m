Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaBYKad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:30:33 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:59401 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaBYKa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:30:26 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/11] ARM: shmobile: MSIOF integration on r8a7790/lager and r8a7791/koelsch
Date: Tue, 25 Feb 2014 11:30:08 +0100
Message-Id: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        Hi Simon, Magnus,

This patch series integrates support for the MSIOF module in the Renesas
R-Car H2 (r8a7790) and M2 (r8a7791) SoCs on the Lager and Koelsch
development boards.

It was tested on Lager and Koelsch, both legacy and DT, using a dummy
driver for the Renesas r2a11302ft PMIC that reads out the PMIC's version
ID.

    [01/11] ARM: shmobile: r8a7790: Add MSIOF clocks
    [02/11] ARM: shmobile: r8a7791: Add MSIOF clocks
    [03/11] ARM: shmobile: lager legacy: Add MSIOF support
    [04/11] ARM: shmobile: koelsch legacy: Add MSIOF support
    [05/11] ARM: shmobile: r8a7790/lager dts: Rename label spi to qspi, add
    	    spi0 alias
    [06/11] ARM: shmobile: r8a7791/koelsch dts: Rename label spi to qspi,
    	    add spi0 alias
    [07/11] ARM: shmobile: r8a7790 dtsi: Add MSIOF nodes and aliases
    [08/11] ARM: shmobile: r8a7791 dtsi: Add MSIOF nodes and aliases
    [09/11] ARM: shmobile: lager dts: Add MSIOF nodes
    [10/11] ARM: shmobile: koelsch dts: Add MSIOF nodes
    [11/11] ARM: shmobile: koelsch/lager/multi defconfig: Enable MSIOF

These are (reworked versions of) the remaining patches not taken from v1.
Changelogs are available in the individual patches.

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
