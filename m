Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaEBGfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 02:35:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40861 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbaEBGfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 02:35:40 -0400
From: George Cherian <george.cherian@ti.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <davem@davemloft.net>, <richardcochran@gmail.com>,
        <jeffrey.t.kirsher@intel.com>, <dborkman@redhat.com>,
        <ast@plumgrid.com>, <tklauser@distanz.ch>, <mpa@pengutronix.de>,
        <bhutchings@solarflare.com>, <zonque@gmail.com>, <balbi@ti.com>,
        <mugunthanvnm@ti.com>, <george.cherian@ti.com>, <t-kristo@ti.com>,
        <mturquette@linaro.org>, <linux@arm.linux.org.uk>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <bcousson@baylibre.com>
Subject: [PATCH v2 6/6] ARM: dts: am4372: Add clock names for cpsw and cpts
Date: Fri, 2 May 2014 12:02:04 +0530
Message-ID: <1399012324-20737-7-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399012324-20737-1-git-send-email-george.cherian@ti.com>
References: <1399012324-20737-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CPSW fck and CPTS clock and clock names for AM4372

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 arch/arm/boot/dts/am4372.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index 36d523a..c2779f6 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -489,6 +489,8 @@
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ti,hwmods = "cpgmac0";
+			clocks = <&cpsw_125mhz_gclk>, <&cpsw_cpts_rft_clk>;
+			clock-names = "fck", "cpts";
 			status = "disabled";
 			cpdma_channels = <8>;
 			ale_entries = <1024>;
-- 
1.8.3.1

