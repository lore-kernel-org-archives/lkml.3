Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbaGCNrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:47:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43786 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaGCNrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:47:07 -0400
From: Keerthy <j-keerthy@ti.com>
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <mark.rutland@arm.com>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH 0/5] ARM: dts: AM43x: Add devcice tree nodes 
Date: Thu, 3 Jul 2014 19:14:57 +0530
Message-ID: <1404395102-21469-1-git-send-email-j-keerthy@ti.com>
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

Keerthy (5):
  mfd: Add DT bindings for tps65218 PMIC
  regulator: Add DT bindings for tps65218 PMIC regulators.
  ARM: dts: AM43x: Add TPS65218 device tree nodes
  ARM: dts: AM437x: Add TPS65218 device tree nodes
  ARM: configs: omap2plus_defconfig: enable TPS65218 configs

 Documentation/devicetree/bindings/mfd/tps65218.txt |   57 ++++++++++++++++++++
 .../devicetree/bindings/regulator/tps65218.txt     |   21 ++++++++
 arch/arm/boot/dts/am437x-gp-evm.dts                |   38 +++++++++++++
 arch/arm/boot/dts/am43x-epos-evm.dts               |   38 +++++++++++++
 arch/arm/configs/omap2plus_defconfig               |    2 +
 5 files changed, 156 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/tps65218.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65218.txt

-- 
1.7.9.5

