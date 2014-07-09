Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaGIMXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:23:54 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:53604 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaGIMXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:23:52 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 00/13] ARM: shmobile: DT bindings and DTS updates
Date: Wed,  9 Jul 2014 14:23:30 +0200
Message-Id: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series aims to improvide the shmobile DT bindings, DT binding
documentation, and the actual device trees.

It reduces the number of checkpatch warnings about un-documented compatible
strings in the DTSes by 50%.

The last 4 patches contain compatible strings for new R-Car Gen2 SoCs,
which are not yet in active use, hence the RFC status.

  [01/13] of: Add vendor prefix for Sitronix
  [02/13] irqchip: renesas-intc-irqpin: Document SoC-specific bindings
  [03/13] irqchip: renesas-irqc: Add DT binding documentation
  [04/13] mmc: tmio-mmc: Add renesas,sdhi-r8a7791 to binding documentation
  [05/13] thermal: rcar: Document SoC-specific bindings
  [06/13] sh-pfc: Add renesas,pfc-r8a7791 to binding documentation
  [07/13] ARM: shmobile: r8a73a4 dtsi: Add SoC-specific irqc compatible
          property
  [08/13] ARM: shmobile: r8a73a4 dtsi: Add SoC-specific thermal compatible
	  property
  [09/13] ARM: shmobile: r8a7779 dtsi: Add SoC-specific thermal compatible
	  property
  [10/13] [RFC] ARM: dts: Add shmobile platform device tree bindings
	  documentation
  [11/13] [RFC] mmc: tmio-mmc: Add support for SDHI on new R-Car Gen2 SoCs
  [12/13] [RFC] thermal: rcar: Add binding docs for new R-Car Gen2 SoCs
  [13/13] [RFC] irqchip: renesas-irqc: Add binding docs for new R-Car Gen2 SoCs

 Documentation/devicetree/bindings/arm/shmobile.txt | 71 ++++++++++++++++++++++
 .../interrupt-controller/renesas,intc-irqpin.txt   |  8 ++-
 .../bindings/interrupt-controller/renesas,irqc.txt | 33 ++++++++++
 Documentation/devicetree/bindings/mmc/tmio_mmc.txt |  4 ++
 .../bindings/pinctrl/renesas,pfc-pinctrl.txt       |  1 +
 .../devicetree/bindings/thermal/rcar-thermal.txt   | 21 +++++--
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 arch/arm/boot/dts/r8a73a4.dtsi                     |  6 +-
 arch/arm/boot/dts/r8a7779.dtsi                     |  2 +-
 drivers/mmc/host/sh_mobile_sdhi.c                  |  3 +
 10 files changed, 139 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/shmobile.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/renesas,irqc.txt

Thanks for your comments!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
