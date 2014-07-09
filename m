Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaGIFiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 01:38:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44648 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbaGIFik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 01:38:40 -0400
From: Keerthy <j-keerthy@ti.com>
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <mark.rutland@arm.com>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, <broonie@kernel.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH v3 0/7] ARM: dts: AM43x: Add devcice tree nodes 
Date: Wed, 9 Jul 2014 11:06:26 +0530
Message-ID: <1404884193-20580-1-git-send-email-j-keerthy@ti.com>
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
  regulator: tps65218: Add fixed_uV fields for dcdc5 and dcdc6
  mfd: Add DT bindings for tps65218 PMIC
  regulator: Add DT bindings for tps65218 PMIC regulators.
  ARM: dts: AM43x: Add TPS65218 device tree nodes
  ARM: dts: AM437x: Fix i2c nodes indentation
  ARM: dts: AM437x: Add TPS65218 device tree nodes
  ARM: configs: omap2plus_defconfig: enable TPS65218 configs

 Documentation/devicetree/bindings/mfd/tps65218.txt |   89 ++++++++++++++++++++
 .../devicetree/bindings/regulator/tps65218.txt     |   23 +++++
 arch/arm/boot/dts/am437x-gp-evm.dts                |   71 ++++++++++++++--
 arch/arm/boot/dts/am43x-epos-evm.dts               |   59 +++++++++++++
 arch/arm/configs/omap2plus_defconfig               |    2 +
 drivers/regulator/tps65218-regulator.c             |   17 ++--
 6 files changed, 246 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/tps65218.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65218.txt

-- 
1.7.9.5

