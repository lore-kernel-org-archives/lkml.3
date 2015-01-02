Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbbABUBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 15:01:08 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44324 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbbABUAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 15:00:54 -0500
From: Dave Gerlach <d-gerlach@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Benoit Cousson <bcousson@baylibre.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Suman Anna <s-anna@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Dave Gerlach <d-gerlach@ti.com>
Subject: [PATCH 3/3] ARM: dts: am33xx: Add wkup_m3_ipc node
Date: Fri, 2 Jan 2015 14:00:17 -0600
Message-ID: <1420228817-41310-4-git-send-email-d-gerlach@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420228817-41310-1-git-send-email-d-gerlach@ti.com>
References: <1420228817-41310-1-git-send-email-d-gerlach@ti.com>
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
index acd3705..1ebb230 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -863,6 +863,15 @@
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

