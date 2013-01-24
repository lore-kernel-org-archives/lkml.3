Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3AXICh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:02:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40940 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3AXICS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:02:18 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <hvaibhav@ti.com>,
        <zonque@gmail.com>, <jacmet@sunsite.dk>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v2 2/3] ARM: dts: AM33XX: Add GPMC node
Date: Thu, 24 Jan 2013 13:32:28 +0530
Message-ID: <2645efefa3d36388ff1d4b64255d880b6587770f.1359007746.git.avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1359007746.git.avinashphilip@ti.com>
References: <cover.1359007746.git.avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Philip, Avinash" <avinashphilip@ti.com>

Add GPMC data node to AM33XX device tree file.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
---
Changes since v2:
	- Change number of chip select to 7

 arch/arm/boot/dts/am33xx.dtsi |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 115bf28..fbcb90b 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -397,5 +397,17 @@
 			ti,hwmods = "elm";
 			status = "disabled";
 		};
+
+		gpmc: gpmc@50000000 {
+			compatible = "ti,am3352-gpmc";
+			ti,hwmods = "gpmc";
+			reg = <0x50000000 0x2000>;
+			interrupts = <100>;
+			num-cs = <7>;
+			num-waitpins = <2>;
+			#address-cells = <2>;
+			#size-cells = <1>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.9.5

