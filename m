Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936453Ab3DQUbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 16:31:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38291 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936299Ab3DQUbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 16:31:06 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <b-cousson@ti.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] arm: dts: add bandgap entry for OMAP443x devices
Date: Wed, 17 Apr 2013 16:29:33 -0400
Message-ID: <1366230574-31547-3-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366230574-31547-1-git-send-email-eduardo.valentin@ti.com>
References: <1366230574-31547-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the bandgap entry for OMAP4430 devices.

Cc: "Benoît Cousson" <b-cousson@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 arch/arm/boot/dts/omap443x.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/omap443x.dtsi b/arch/arm/boot/dts/omap443x.dtsi
index cccf39a..8d6c968 100644
--- a/arch/arm/boot/dts/omap443x.dtsi
+++ b/arch/arm/boot/dts/omap443x.dtsi
@@ -24,4 +24,8 @@
 			clock-latency = <300000>; /* From legacy driver */
 		};
 	};
+	bandgap {
+		reg = <0x4a002260 0x4 0x4a00232C 0x4>;
+		compatible = "ti,omap4430-bandgap";
+	};
 };
-- 
1.8.2.1.342.gfa7285d

