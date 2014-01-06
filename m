Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbaAFMI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:08:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44876 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbaAFMIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:08:25 -0500
From: Satish Patel <satish.patel@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <rob@landley.net>, <gregkh@linuxfoundation.org>, <arnd@arndb.de>
Subject: [RFC PATCH v1 4/5] ARM: dts: AM43xx: DT entries added for ti-usim
Date: Mon, 6 Jan 2014 17:37:41 +0530
Message-ID: <1389010062-17185-5-git-send-email-satish.patel@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1389010062-17185-1-git-send-email-satish.patel@ti.com>
References: <1389010062-17185-1-git-send-email-satish.patel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SoC specific DT entries added for TI's USIM - smart card controller of AM43xx
platfrom.

Signed-off-by: Satish Patel <satish.patel@ti.com>
---
 arch/arm/boot/dts/am4372.dtsi |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index fc220a4..cc47aff 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -1071,6 +1071,17 @@
 			clocks = <&mcasp1_fck>;
 			clock-names = "fck";
 		};
+
+		usim0: usim@48034000 {
+			compatible = "ti,usim";
+			reg = <0x48034000 0x1000>;
+			interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
+			ti,hwmods = "usim0";
+			clocks = <&usim0_opt_fck>, <&usim0_opt_fck32>;
+			clock-names = "opt_fck", "opt_fck32";
+			status = "disabled";
+		};
+
 	};
 
 	clocks {
-- 
1.7.1

