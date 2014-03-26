Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaCZN7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:59:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33782 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017AbaCZN7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:59:16 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <bhelgaas@google.com>, <mohit.kumar@st.com>, <jg1.han@samsung.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <tony@atomide.com>,
        <rnayak@ti.com>, <paul@pwsan.com>, <kishon@ti.com>,
        Keerthy <j-keerthy@ti.com>
Subject: [RFC PATCH 05/12] ARM: dts: DRA7: Change the parent of apll_pcie_in_clk_mux to dpll_pcie_ref_m2ldo_ck
Date: Wed, 26 Mar 2014 19:27:45 +0530
Message-ID: <1395842272-15267-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395842272-15267-1-git-send-email-kishon@ti.com>
References: <1395842272-15267-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keerthy <j-keerthy@ti.com>

Change the parent of apll_pcie_in_clk_mux to dpll_pcie_ref_m2ldo_ck
from dpll_pcie_ref_ck.

Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/dra7xx-clocks.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
index d909484..9e0bb09 100644
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

