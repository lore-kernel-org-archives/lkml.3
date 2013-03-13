Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214Ab3CMTwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:52:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10340 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3CMTwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:52:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 13 Mar 2013 12:45:18 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 0/5] ARM: DT: tegra114: Add DT entry for different controller
Date: Thu, 14 Mar 2013 01:19:49 +0530
Message-ID: <1363204194-19487-1-git-send-email-ldewangan@nvidia.com>
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
- Add reason why APBDMA is not compatible with older driver
  in description.
- Remove UARTB car id correction. Make the compatible with tegra114 and
  older chip.
- Add compatible for kbc as nvidia,tegra114-kbc and nvidia,tegra20-kbc.

Changes from V2:
- Rebase whole tree with Stephen tegra tree for-3.10/dt.
- Rephrase the commit subjects.
- Add more description about why driver is not compatible with prev hardware.

Laxman Dewangan (5):
  ARM: tegra: add APB DMA nodes to Tegra114 DT
  ARM: tegra: add i2c nodes to Tegra114 DT
  ARM: tegra:add aliases and DMA requestor for serial nodes of Tegra114
  ARM: tegra: add KBC nodes to Tegra114 DT
  ARM: tegra: add spi nodes to Tegra114 DT

 arch/arm/boot/dts/tegra114.dtsi |  200 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 196 insertions(+), 4 deletions(-)

