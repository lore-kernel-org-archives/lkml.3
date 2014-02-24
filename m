Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaBXQZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:25:32 -0500
Received: from top.free-electrons.com ([176.31.233.9]:54515 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753400AbaBXQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:25:10 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/5] Add support for the Allwinner A31 DMA Controller
Date: Mon, 24 Feb 2014 17:22:42 +0100
Message-Id: <1393258967-4843-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds support for the DMA controller found in the
Allwinner A31 and A23 SoCs.

This has been tested using the newly introduced SPI driver on an A31
EVK. Support for DMA-driven SPI transfers will be the subject of
another patch serie.

Thanks,
Maxime

Maxime Ripard (5):
  clk: sun6i: Protect CPU clock
  clk: sun6i: Reparent AHB clock on PLL6
  clk: sun6i: Protect SDRAM gating bit
  DMA: sun6i: Add driver for the Allwinner A31 DMA controller
  ARM: sun6i: dt: Add A31 DMA controller to DTSI

 .../devicetree/bindings/dma/sun6i-dma.txt          |  45 +
 arch/arm/boot/dts/sun6i-a31.dtsi                   |  29 +
 drivers/clk/sunxi/clk-sunxi.c                      |  33 +-
 drivers/dma/Kconfig                                |   8 +
 drivers/dma/Makefile                               |   1 +
 drivers/dma/sun6i-dma.c                            | 960 +++++++++++++++++++++
 6 files changed, 1075 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/dma/sun6i-dma.txt
 create mode 100644 drivers/dma/sun6i-dma.c

-- 
1.9.0

