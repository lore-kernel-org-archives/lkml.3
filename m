Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbaEFNiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:38:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44271 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689AbaEFNfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:35:38 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <rogerq@ti.com>, <balajitk@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 12/17] ARM: dts: dra7: Add dt data for PCIe PHY control module
Date: Tue, 6 May 2014 19:03:58 +0530
Message-ID: <1399383244-14556-13-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399383244-14556-1-git-send-email-kishon@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added dt data for PCIe PHY control module used by PCIe PHY.
The documention for this node can be found @ ../bindings/phy/ti-phy.txt

Cc: Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index f0ca46d..0d3c8c0 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -876,6 +876,14 @@
 			};
 		};
 
+		omap_control_pcie1phy: omap-control-pciephy@0x4a003c40 {
+			compatible = "ti,control-phy-pcie";
+			reg = <0x4a003c40 0x4>, <0x4a003c14 0x4>, <0x4a003c34 0x4>;
+			reg-names = "power", "control_sma", "pcie_pcs";
+			clocks = <&sys_clkin1>;
+			clock-names = "sysclk";
+		};
+
 		/* OCP2SCP3 */
 		ocp2scp@4a090000 {
 			compatible = "ti,omap-ocp2scp";
-- 
1.7.9.5

