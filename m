Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125Ab3FSChi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 22:37:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50337 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933453Ab3FSChh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 22:37:37 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <benoit.cousson@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        J Keerthy <j-keerthy@ti.com>
Subject: [PATCH 1/1] arm: add bandgap DT entry for OMAP5
Date: Tue, 18 Jun 2013 22:36:38 -0400
Message-ID: <1371609398-26454-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bandgap device DT entry for OMAP5 dtsi.

Cc: "Benoît Cousson" <b-cousson@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)
---

Benoit,

Sorry for this very late request, but can you please consider
these patches for 3.11 still?

I completely forgot to send these on my "Enable TI SoC thermal driver" series.

All best,

Eduardo

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 2ad63c4..5ede6e1 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -615,5 +615,13 @@
 			interrupts = <0 80 0x4>;
 			ti,hwmods = "wd_timer2";
 		};
+		bandgap {
+			reg = <0x4a0021e0 0xc
+				0x4a00232c 0xc
+				0x4a002380 0x2c
+				0x4a0023C0 0x3c>;
+				interrupts = <0 126 4>; /* talert */
+			compatible = "ti,omap5430-bandgap";
+		};
 	};
 };
-- 
1.8.2.1.342.gfa7285d

