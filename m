Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab3ARJva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 04:51:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48995 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab3ARJv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 04:51:27 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <tony@atomide.com>,
        <balbi@ti.com>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <linux@arm.linux.org.uk>, <kishon@ti.com>
Subject: [PATCH 2/3] ARM: dts: omap: Add omap-usb2 dt data
Date: Fri, 18 Jan 2013 15:21:15 +0530
Message-ID: <1358502676-27193-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358502676-27193-1-git-send-email-kishon@ti.com>
References: <1358502676-27193-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add omap-usb2 data node in omap4 device tree file. Since omap-usb2 is
connected to ocp2scp, omap-usb2 dt data is added as a child node
of ocp2scp.

Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index ad837e6..d69d6f2 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -438,6 +438,10 @@
 			#size-cells = <1>;
 			ranges;
 			ti,hwmods = "ocp2scp_usb_phy";
+			usb2_phy: usb2phy@4a0ad080 {
+				compatible = "ti,omap-usb2";
+				reg = <0x4a0ad080 0x58>;
+			};
 		};
 
 		timer1: timer@4a318000 {
-- 
1.7.9.5

