Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761871Ab3JPUVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:21:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34863 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761719Ab3JPUVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:21:35 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Rajendra Nayak <rnayak@ti.com>, Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 2/2] ARM: dts: AM33xx+: Add i2c aliases
Date: Wed, 16 Oct 2013 15:21:04 -0500
Message-ID: <1381954864-24410-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381954864-24410-1-git-send-email-nm@ti.com>
References: <525E8D91.5090400@ti.com>
 <1381954864-24410-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide alias to allow ordering the i2c devices correctly.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |    3 +++
 arch/arm/boot/dts/am4372.dtsi |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 09f16a0..defc0d5 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -18,6 +18,9 @@
 	interrupt-parent = <&intc>;
 
 	aliases {
+		i2c0 = &i2c0;
+		i2c1 = &i2c1;
+		i2c2 = &i2c2;
 		serial0 = &uart0;
 		serial1 = &uart1;
 		serial2 = &uart2;
diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index 4944b1a..c7c3160 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -18,6 +18,9 @@
 
 
 	aliases {
+		i2c0 = &i2c0;
+		i2c1 = &i2c1;
+		i2c2 = &i2c2;
 		serial0 = &uart0;
 	};
 
-- 
1.7.9.5

