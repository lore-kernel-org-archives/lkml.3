Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab3JIXa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:30:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43897 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab3JIXau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:30:50 -0400
From: Nishanth Menon <nm@ti.com>
To: Kevin Hilman <khilman@linaro.org>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Nishanth Menon <nm@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH V6 13/15] ARM: dts: AM33XX: add clock nodes for CPU
Date: Wed, 9 Oct 2013 18:30:12 -0500
Message-ID: <1381361414-8851-11-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381361414-8851-1-git-send-email-nm@ti.com>
References: <1381354144-7134-1-git-send-email-nm@ti.com>
 <1381361414-8851-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AM33XX based platforms use dpll_mpu clock. Add same to common dtsi
and remove the dummy clock node entry as AM33XX platform supports
only device tree based boot.

Cc: Benoit Cousson <bcousson@baylibre.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 2a994d6..09f16a0 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -55,6 +55,10 @@
 				275000  1125000
 			>;
 			voltage-tolerance = <2>; /* 2 percentage */
+
+			clocks = <&dpll_mpu_ck>;
+			clock-names = "cpu";
+
 			clock-latency = <300000>; /* From omap-cpufreq driver */
 		};
 	};
-- 
1.7.9.5

