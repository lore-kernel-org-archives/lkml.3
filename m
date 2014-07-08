Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaGHKX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:23:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51192 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbaGHKXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:23:25 -0400
From: Keerthy <j-keerthy@ti.com>
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <mark.rutland@arm.com>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, <broonie@kernel.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH v2 0/7] ARM: dts: AM43x: Add devcice tree nodes
Date: Tue, 8 Jul 2014 15:46:30 +0530
Message-ID: <1404814597-4404-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series adds the device tree nodes and the corresponding
documentation. The series also enabled tps65218 config options
in the omap2plus_defconfig.

The series is boot tested on both AM43x-epos-evm and AM437x-gp-evm.

Keerthy (7):
  mfd: Add DT bindings for tps65218 PMIC
  regulator: Add DT bindings for tps65218 PMIC regulators.
  ARM: dts: AM43x: Add TPS65218 device tree nodes
  ARM: dts: AM437x: Fix i2c nodes indentation
  ARM: dts: AM437x: Add TPS65218 device tree nodes
  regulator: tps65218: Add get_voltage ops for dcdc5 and dcdc6
  ARM: configs: omap2plus_defconfig: enable TPS65218 configs

 Documentation/devicetree/bindings/mfd/tps65218.txt |   89 ++++++++++++++++++++
 .../devicetree/bindings/regulator/tps65218.txt     |   23 +++++
 arch/arm/boot/dts/am437x-gp-evm.dts                |   71 ++++++++++++++--
 arch/arm/boot/dts/am43x-epos-evm.dts               |   59 +++++++++++++
 arch/arm/configs/omap2plus_defconfig               |    2 +
 drivers/regulator/tps65218-regulator.c             |    9 ++
 6 files changed, 246 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/tps65218.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65218.txt

-- 
1.7.9.5

