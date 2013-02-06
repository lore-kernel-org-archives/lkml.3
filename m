Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab3BFO5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:57:25 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38994 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab3BFO5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:57:16 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH 8/8] ARM: dts: omap5: add dwc3 core dt data
Date: Wed, 6 Feb 2013 20:26:44 +0530
Message-ID: <1360162604-14320-9-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360162604-14320-1-git-send-email-kishon@ti.com>
References: <1360162604-14320-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dwc3 core dt data as a subnode to dwc3 omap glue data in omap5 dt
data file. The information for the entered data node is available @
Documentation/devicetree/bindings/usb/dwc3.txt

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index c4eb2ec..24dd69f 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -514,6 +514,13 @@
 			#size-cells = <1>;
 			utmi-mode = <2>;
 			ranges;
+			dwc3@4a030000 {
+				compatible = "synopsys,dwc3";
+				reg = <0x4a030000 0x1000>;
+				interrupts = <0 92 4>;
+				usb-phy = <&usb2_phy>, <&usb3_phy>;
+				tx-fifo-resize;
+			};
 		};
 
 		ocp2scp {
-- 
1.7.10.4

