Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab3AYDTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:19:48 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48590 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab3AYDSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:18:52 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <s-guiriec@ti.com>, <gg@slimlogic.co.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] ARM: dts: omap5: Add ocp2scp data
Date: Fri, 25 Jan 2013 08:48:31 +0530
Message-ID: <1359083915-8690-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359083915-8690-1-git-send-email-kishon@ti.com>
References: <1359083915-8690-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ocp2scp data node in omap5 device tree file. The information for
the node added here can be found @
Documentation/devicetree/bindings/bus/omap-ocp2scp.txt

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index edc7464..d149330 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -512,5 +512,13 @@
 			reg-names = "control_dev_conf", "phy_power_usb";
 			ti,type = <2>;
 		};
+
+		ocp2scp {
+			compatible = "ti,omap-ocp2scp";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			ti,hwmods = "ocp2scp1";
+		};
 	};
 };
-- 
1.7.9.5

