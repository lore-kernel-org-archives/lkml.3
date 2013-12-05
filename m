Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab3LEKvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:51:21 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3224 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab3LEKvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:51:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Dec 2013 02:45:49 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <thierry.reding@gmail.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 0/4] ARM: tegra: convert dts files of all Tegra platforms to use pinctrl defines
Date: Thu, 5 Dec 2013 16:14:05 +0530
Message-ID: <1386240249-30786-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series convert dts files of all Tegra's platforms to use the pinctron
dt-binding macro for better readability.

Changes from V1:
- Get rid of lots of macro and converge it to TEGRA_PIN_ENABLE/DISABLE.
- Change macro name for PULL UP/DOWN/NONE.

Changes from V2:
- Add more comment on defines.
- Add two more patches for having simialr change for Tegra20 and Tegra30 platforms.

Laxman Dewangan (4):
  ARM: tegra: Add header file for pinctrl constants
  ARM: tegra: convert dts files of Tegra114 platforms to use pinctrl
    defines
  ARM: tegra: convert dts files of Tegra20 platforms to use pinctrl
    defines
  ARM: tegra: convert dts files of Tegra30 platforms to use pinctrl
    defines

 arch/arm/boot/dts/tegra114-dalmore.dts      |  548 +++++++++++++-------------
 arch/arm/boot/dts/tegra114.dtsi             |    1 +
 arch/arm/boot/dts/tegra20-colibri-512.dtsi  |  104 +++---
 arch/arm/boot/dts/tegra20-harmony.dts       |   30 +-
 arch/arm/boot/dts/tegra20-iris-512.dts      |   10 +-
 arch/arm/boot/dts/tegra20-paz00.dts         |   30 +-
 arch/arm/boot/dts/tegra20-seaboard.dts      |   44 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi     |   30 +-
 arch/arm/boot/dts/tegra20-trimslice.dts     |   34 +-
 arch/arm/boot/dts/tegra20-ventana.dts       |   44 +-
 arch/arm/boot/dts/tegra20-whistler.dts      |   40 +-
 arch/arm/boot/dts/tegra20.dtsi              |    1 +
 arch/arm/boot/dts/tegra30-beaver.dts        |   34 +-
 arch/arm/boot/dts/tegra30-cardhu.dtsi       |   40 +-
 arch/arm/boot/dts/tegra30.dtsi              |    1 +
 include/dt-bindings/pinctrl/pinctrl-tegra.h |   45 +++
 16 files changed, 542 insertions(+), 494 deletions(-)
 create mode 100644 include/dt-bindings/pinctrl/pinctrl-tegra.h

