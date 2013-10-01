Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab3JASed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 14:34:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44449 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab3JASe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 14:34:29 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <grant.likely@linaro.org>
CC: <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 3/7] arm: dts: dra7: add bandgap entry
Date: Tue, 1 Oct 2013 14:32:20 -0400
Message-ID: <1380652344-18819-4-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com>
References: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds bandgap IP entry on DRA7 dtsi device tree file.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 3a746c2..4e9b159 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -53,6 +53,18 @@
 		};
 	};
 
+	bandgap: bandgap {
+		reg = <0x4a0021e0 0xc
+			0x4a00232c 0xc
+			0x4a002380 0x2c
+			0x4a0023C0 0x3c
+			0x4a002564 0x8
+			0x4a002574 0x50>;
+		compatible = "ti,dra752-bandgap";
+		interrupts = <GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH>;
+		#thermal-sensor-cells = <1>;
+	};
+
 	gic: interrupt-controller@48211000 {
 		compatible = "arm,cortex-a15-gic";
 		interrupt-controller;
-- 
1.8.2.1.342.gfa7285d

