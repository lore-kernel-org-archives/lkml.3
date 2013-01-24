Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3AXIC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:02:26 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48910 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab3AXICF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:02:05 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <hvaibhav@ti.com>,
        <zonque@gmail.com>, <jacmet@sunsite.dk>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v2 1/3] ARM: dts: AM33XX: Add ELM node
Date: Thu, 24 Jan 2013 13:32:27 +0530
Message-ID: <7fa7438c9a7c5da575d762423815625d523c4689.1359007746.git.avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1359007746.git.avinashphilip@ti.com>
References: <cover.1359007746.git.avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Philip, Avinash" <avinashphilip@ti.com>

Add ELM data node to AM33XX device tree file.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
---
Changes since v2:
	- Replace <xx> literals to 52
	- remove tab

 arch/arm/boot/dts/am33xx.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index da79618..115bf28 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -389,5 +389,13 @@
 				mac-address = [ 00 00 00 00 00 00 ];
 			};
 		};
+
+		elm: elm@48080000 {
+			compatible = "ti,am3352-elm";
+			reg = <0x48080000 0x2000>;
+			interrupts = <4>;
+			ti,hwmods = "elm";
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.9.5

