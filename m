Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaCGL76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:59:58 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53305 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbaCGL64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:58:56 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <anatol.pomozov@gmail.com>,
        <bcousson@baylibre.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v3 2/5] ARM: dts: am43xx clock data
Date: Fri, 7 Mar 2014 17:26:59 +0530
Message-ID: <1394193422-18242-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394193422-18242-1-git-send-email-george.cherian@ti.com>
References: <1394193422-18242-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add USB reference clock data

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 arch/arm/boot/dts/am43xx-clocks.dtsi | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/am43xx-clocks.dtsi b/arch/arm/boot/dts/am43xx-clocks.dtsi
index 142009c..506d036 100644
--- a/arch/arm/boot/dts/am43xx-clocks.dtsi
+++ b/arch/arm/boot/dts/am43xx-clocks.dtsi
@@ -653,4 +653,21 @@
 		clocks = <&clk_32768_ck>, <&clk_32k_tpm_ck>;
 		reg = <0x4260>;
 	};
+
+	usb_otg_ss0_refclk960m: usb_otg_ss0_refclk960m {
+		#clock-cells = <0>;
+	        compatible = "ti,gate-clock";
+		clocks = <&dpll_per_clkdcoldo>;
+	        ti,bit-shift = <8>;
+	        reg = <0x8a60>;
+	};
+
+	usb_otg_ss1_refclk960m: usb_otg_ss1_refclk960m {
+		#clock-cells = <0>;
+	        compatible = "ti,gate-clock";
+		clocks = <&dpll_per_clkdcoldo>;
+	        ti,bit-shift = <8>;
+		reg = <0x8a68>;
+	};
+
 };
-- 
1.8.3.1

