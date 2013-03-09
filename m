Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab3CISNM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:13:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5556 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3CISNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:13:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 09 Mar 2013 10:13:04 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pdeschrijver@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/5] ARM: DT: tegra114: Add DT entry for different controller
Date: Sat, 9 Mar 2013 23:41:13 +0530
Message-ID: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add DT entry for APB DMA, I2C, UART, KBC and SPI.

This patch series is generated on top of CCF work for T114 done by Peter
and hence it should be applied on top of T114 CCF patches.

Changes from V1:
- Add reeason why APBDMA is not compatible with older driver
  in description.
- Remove UARTB car id correction. Make the compatible with tegra114 and
  older chip.
- Add compatible for kbc as nvidia,tegra114-kbc and nvidia,tegra20-kbc.

Laxman Dewangan (5):
  ARM: DT: tegra114: add APB DMA controller DT entry
  ARM: DT: tegra114: Add i2c controller DT entry
  ARM: DT: tegra114:add aliases and DMA requestor for serial controller
  ARM: DT: tegra114: add KBC controller DT entry
  ARM: DT: tegra114: Add spi controller DT entry

 arch/arm/boot/dts/tegra114.dtsi |  200 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 196 insertions(+), 4 deletions(-)

