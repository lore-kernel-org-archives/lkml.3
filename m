Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbaEFNf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:35:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44234 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaEFNfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:35:17 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <rogerq@ti.com>, <balajitk@ti.com>, Keerthy <j-keerthy@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 08/17] ARM: dts: DRA7: Change the parent of apll_pcie_in_clk_mux to dpll_pcie_ref_m2ldo_ck
Date: Tue, 6 May 2014 19:03:54 +0530
Message-ID: <1399383244-14556-9-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399383244-14556-1-git-send-email-kishon@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keerthy <j-keerthy@ti.com>

Change the parent of apll_pcie_in_clk_mux to dpll_pcie_ref_m2ldo_ck
from dpll_pcie_ref_ck.

Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/dra7xx-clocks.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
index 55e95c5..44993ec 100644
--- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
+++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
@@ -1152,7 +1152,7 @@
 
 	apll_pcie_in_clk_mux: apll_pcie_in_clk_mux@4ae06118 {
 		compatible = "ti,mux-clock";
-		clocks = <&dpll_pcie_ref_ck>, <&pciesref_acs_clk_ck>;
+		clocks = <&dpll_pcie_ref_m2ldo_ck>, <&pciesref_acs_clk_ck>;
 		#clock-cells = <0>;
 		reg = <0x021c 0x4>;
 		ti,bit-shift = <7>;
-- 
1.7.9.5

