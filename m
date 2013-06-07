Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab3FGUsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 16:48:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55660 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab3FGUsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 16:48:15 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <tony@atomide.com>, <grant.likely@linaro.org>
CC: <linux-pm@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, Eduardo Valentin <eduardo.valentin@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 3/6] arm: dts: add bandgap entry for OMAP443x devices
Date: Fri, 7 Jun 2013 16:46:05 -0400
Message-ID: <1370637968-23299-4-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1370637968-23299-1-git-send-email-eduardo.valentin@ti.com>
References: <1370637968-23299-1-git-send-email-eduardo.valentin@ti.com>
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

