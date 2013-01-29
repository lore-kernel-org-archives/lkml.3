Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3A2M6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:58:54 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5697 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3A2M6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:58:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 29 Jan 2013 04:58:05 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/7] ARM: DT: tegra114: add dt entry for gpio/pinmux/dma/i2c/serial/kbc
Date: Tue, 29 Jan 2013 18:26:16 +0530
Message-ID: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add DT entry for the NVIDIA's Tegra114 SoCs for the following
controller:
- GPIO controller
- DMA controller.
- Pinmux controller.
- I2c controller.
- KBC controler.

Also add dma requestor and aliases for serial channel.

Laxman Dewangan (7):
  ARM: tegra114: select PINCTRL for Tegra114 SoC
  ARM: DT: tegra114: add GPIO DT entry
  ARM: DT: tegra114: add APB DMA controller DT entry
  ARM: DT: tegra114: add pinmux DT entry
  ARM: DT: tegra114: Add i2c controller DT entry
  ARM: DT: tegra114:add aliases and DMA requestor for serial controller
  ARM: DT: tegra114: add KBC controller DT entry

 arch/arm/boot/dts/tegra114.dtsi |  139 +++++++++++++++++++++++++++++++++++++-
 arch/arm/mach-tegra/Kconfig     |    2 +
 2 files changed, 137 insertions(+), 4 deletions(-)

