Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3LELBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:01:12 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4004 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3LELBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:01:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 05 Dec 2013 02:54:26 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linus.walleij@linaro.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <thierry.reding@gmail.com>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/4] pinctrl: tegra: Add pincontrol driver for Tegra124 SoC
Date: Thu, 5 Dec 2013 16:27:46 +0530
Message-ID: <1386241070-4350-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pincontrol driver for NVIDIA's Tegra124 SoCs.
This series add pincontrol driver which contains the pinmux tables
for tegra124, pincontrol dt binding doc, dtsi file change for adding
pinmux node, selecting pincontrol config for Tegra124.

Ashwini Ghuge (1):
  pinctrl: tegra: add pinmux controller driver for Tegra124

Laxman Dewangan (3):
  pinctrl: tegra: Add devicetree binding document for Tegra124
  ARM: tegra: add pinmux controller to tegra124.dtsi
  ARM: tegra: select PINCTRL_TEGRA124 for Tegra124 SoC

 .../bindings/pinctrl/nvidia,tegra124-pinmux.txt    |  137 +
 arch/arm/boot/dts/tegra124.dtsi                    |    6 +
 arch/arm/mach-tegra/Kconfig                        |    1 +
 drivers/pinctrl/Kconfig                            |    4 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-tegra124.c                 | 3147 ++++++++++++++++++++
 6 files changed, 3296 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-pinmux.txt
 create mode 100644 drivers/pinctrl/pinctrl-tegra124.c

