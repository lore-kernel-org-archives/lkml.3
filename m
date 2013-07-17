Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab3GQPS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:18:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51065 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab3GQPSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:18:54 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>
CC: <wni@nvidia.com>, <l.stach@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [RESEND PATCH V1 4/9] arm: dts: flag omap4430 with needs-cooling for cpu node
Date: Wed, 17 Jul 2013 11:17:23 -0400
Message-ID: <1374074248-31690-5-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com>
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP4430 devices can reach high temperatures and thus
needs to have cpufreq-cooling on systems running on it.

This patch adds the flag so that cpufreq-cpu0 driver
loads the cooling device to use cpufreq on OMAP4430.

Cc: "Benoît Cousson" <b-cousson@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 arch/arm/boot/dts/omap443x.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/omap443x.dtsi b/arch/arm/boot/dts/omap443x.dtsi
index bcf455e..4a4dcc3 100644
--- a/arch/arm/boot/dts/omap443x.dtsi
+++ b/arch/arm/boot/dts/omap443x.dtsi
@@ -22,6 +22,7 @@
 				1008000 1375000
 			>;
 			clock-latency = <300000>; /* From legacy driver */
+			needs-cooling; /* make sure we have cpufreq-cooling */
 		};
 	};
 
-- 
1.8.2.1.342.gfa7285d

