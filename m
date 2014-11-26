Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaKZViz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:38:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34216 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbaKZVix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:38:53 -0500
From: Dave Gerlach <d-gerlach@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Kevin Hilman <khilman@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Suman Anna <s-anna@ti.com>, Dave Gerlach <d-gerlach@ti.com>
Subject: [RFC PATCH 3/3] ARM: dts: am33xx: Add wkup_m3_ipc node
Date: Wed, 26 Nov 2014 15:38:10 -0600
Message-ID: <4981daf0740253def2cfcf11a2994526191d9f32.1417029919.git.d-gerlach@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1417029919.git.d-gerlach@ti.com>
References: <cover.1417029919.git.d-gerlach@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add wkup_m3_ipc node for wkup_m3_ipc driver.

Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 41659df..b86d8c0 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -848,6 +848,15 @@
 			reg = <0x48310000 0x2000>;
 			interrupts = <111>;
 		};
+
+		wkup_m3_ipc: wkup_m3_ipc@44e11324 {
+			compatible = "ti,am3353-wkup-m3-ipc";
+			reg = <0x44e11324 0x0024>;
+			reg-names = "ipc_regs";
+			interrupts = <78>;
+			ti,rproc = <&wkup_m3>;
+			mboxes = <&mailbox &mbox_wkupm3>;
+		};
 	};
 };
 
-- 
2.1.0

