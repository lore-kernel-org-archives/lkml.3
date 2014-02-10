Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaBJKrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:47:46 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:37428 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaBJKrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:47:42 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] ARM: shmobile: r8a7790/Lager QSPI SoC/board integration
Date: Mon, 10 Feb 2014 11:47:26 +0100
Message-Id: <1392029254-15400-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Simon, Magnus,

The following patch series completes r8a7790 SoC and Lager board
integration for the Renesas Quad Serial Peripheral Interface. It brings
r8a7790/Lager to the same support level as r8a7791/Koelsch, allowing access
to the Spansion s25fl512s SPI FLASH for both legacy and multi-platform
kernels.

    [1/7] pinctrl: sh-pfc: r8a7790: Add QSPI pin groups
    [2/7] ARM: shmobile: lager legacy: Add QSPI pinmux
    [3/7] ARM: shmobile: r8a7790 dtsi: Add QSPI node
    [4/7] ARM: shmobile: lager dts: Add QSPI nodes
    [5/7] ARM: shmobile: lager defconfig: Enable RSPI and MTD_M25P80
    [6/7] ARM: shmobile: lager legacy: Enable Quad SPI transfers for the SPI
	  FLASH
    [7/7] ARM: shmobile: lager dts: Enable Quad SPI transfers for the SPI
         FLASH

Please do _not_ apply patches [6/7] and [7/7] yet, as these have a runtime
dependency on Quad SPI support in the RSPI/QSPI driver, which is queued up
in the linux-spi tree for v3.15.

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
