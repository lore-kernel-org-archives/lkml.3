Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaE1I7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:59:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56069 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaE1I6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:58:05 -0400
From: Satish Patel <satish.patel@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rob@landley.net>, <tony@atomide.com>
CC: <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        Satish Patel <satish.patel@ti.com>
Subject: [PATCH v3 4/5] ARM: dts: AM43xx: DT entries added for ti-usim
Date: Wed, 28 May 2014 14:27:16 +0530
Message-ID: <1401267437-22489-5-git-send-email-satish.patel@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401267437-22489-1-git-send-email-satish.patel@ti.com>
References: <1401267437-22489-1-git-send-email-satish.patel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SoC specific DT entries added for TI's USIM - smart card controller of AM43xx
platfrom.

Signed-off-by: Satish Patel <satish.patel@ti.com>
---
 arch/arm/boot/dts/am4372.dtsi |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index d1f8707..fe830dd 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -735,6 +735,18 @@
 			#size-cells = <1>;
 			status = "disabled";
 		};
+
+		usim0: usim@48034000 {
+			compatible = "ti,usim";
+			reg = <0x48034000 0x1000>;
+			interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
+			ti,hwmods = "usim0";
+			clocks = <&usim0_opt_fck>, <&usim0_opt_fck32>,
+				 <&dpll_per_m2_div4_ck>;
+			clock-names = "opt_fck", "opt_fck32", "fck";
+			status = "disabled";
+		};
+
 	};
 };
 
-- 
1.7.9.5

