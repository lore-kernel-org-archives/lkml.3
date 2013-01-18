Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab3ARGlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 01:41:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48478 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab3ARGlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 01:41:15 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <zonque@gmail.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 2/3] ARM: dts: AM33XX: Add GPMC node
Date: Fri, 18 Jan 2013 12:11:34 +0530
Message-ID: <1358491295-4022-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358491295-4022-1-git-send-email-avinashphilip@ti.com>
References: <1358491295-4022-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Philip, Avinash" <avinashphilip@ti.com>

Add GPMC data node to AM33XX device tree file.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index eaef5e7..f4209d8 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -393,5 +393,17 @@
 			ti,hwmods = "elm";
 			status = "disabled";
 		};
+
+		gpmc: gpmc@50000000 {
+			compatible = "ti,am3352-gpmc";
+			ti,hwmods = "gpmc";
+			reg = <0x50000000 0x2000>;
+			interrupts = <100>;
+			num-cs = <8>;
+			num-waitpins = <2>;
+			#address-cells = <2>;
+			#size-cells = <1>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.9.5

