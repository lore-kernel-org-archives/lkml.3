Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaATEew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 23:34:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50244 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaATEej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 23:34:39 -0500
From: Satish Patel <satish.patel@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rob@landley.net>
CC: Satish Patel <satish.patel@ti.com>
Subject: [PATCH v2 4/5] ARM: dts: AM43xx: DT entries added for ti-usim
Date: Mon, 20 Jan 2014 10:03:53 +0530
Message-ID: <1390192434-19386-5-git-send-email-satish.patel@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1390192434-19386-1-git-send-email-satish.patel@ti.com>
References: <1390192434-19386-1-git-send-email-satish.patel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SoC specific DT entries added for TI's USIM - smart card controller of AM43xx
platfrom.

Signed-off-by: Satish Patel <satish.patel@ti.com>
---
 arch/arm/boot/dts/am4372.dtsi |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index 974d103..7ed1cd1 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -663,5 +663,15 @@
 			       <&edma 11>;
 			dma-names = "tx", "rx";
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
 	};
 };
-- 
1.7.1

