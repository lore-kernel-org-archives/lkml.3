Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3AXIiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:38:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50426 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab3AXIhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:37:37 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <linux@arm.linux.org.uk>, <nsekhar@ti.com>,
        <khilman@deeprootsystems.com>, <hs@denx.de>, <anilkumar.v@ti.com>
Subject: [PATCH 1/2] ARM: davinci: da850: add wdt DT node
Date: Thu, 24 Jan 2013 14:08:14 +0530
Message-ID: <1359016695-10362-2-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359016695-10362-1-git-send-email-anilkumar.v@ti.com>
References: <1359016695-10362-1-git-send-email-anilkumar.v@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add da850 wdt DT node.

Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
---
:100644 100644 37dc5a3... 4666ce9... M	arch/arm/boot/dts/da850-evm.dts
:100644 100644 640ab75... 08bf974... M	arch/arm/boot/dts/da850.dtsi
 arch/arm/boot/dts/da850-evm.dts |    3 +++
 arch/arm/boot/dts/da850.dtsi    |    5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index 37dc5a3..4666ce9 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -24,5 +24,8 @@
 		serial2: serial@1d0d000 {
 			status = "okay";
 		};
+		wdt: wdt@1c21000 {
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 640ab75..08bf974 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -56,5 +56,10 @@
 			interrupt-parent = <&intc>;
 			status = "disabled";
 		};
+		wdt: wdt@1c21000 {
+			compatible = "ti,davinci-wdt";
+			reg = <0x21000 0xfff>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.4.1

