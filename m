Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab3AONvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:51:55 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59730 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3AONt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:49:57 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Sekhar Nori <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/5] ARM: dts: AM33XX: Add am335x-evm lcdc panel timings
Date: Tue, 15 Jan 2013 19:20:49 +0530
Message-ID: <539390a5b79a0a87bec4d53777fa6dde6af7c51d.1358252955.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1358252955.git.afzal@ti.com>
References: <cover.1358252955.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update lcdc node with panel timings (typical) for AM335X-EVM.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/boot/dts/am335x-evm.dts |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index d649644..a4229aa 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -244,3 +244,23 @@
 &cpsw_emac1 {
 	phy_id = <&davinci_mdio>, <1>;
 };
+
+&lcdc {
+	status = "okay";
+
+	display-timings {
+		800x480p62 {
+			clock-frequency = <30000000>;
+			hactive = <800>;
+			vactive = <480>;
+			hfront-porch = <39>;
+			hback-porch = <39>;
+			hsync-len = <47>;
+			vback-porch = <29>;
+			vfront-porch = <13>;
+			vsync-len = <2>;
+			hsync-active = <1>;
+			vsync-active = <1>;
+		};
+	};
+};
-- 
1.7.9.5

