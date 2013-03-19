Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab3CSO1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:27:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53269 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab3CSO13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:27:29 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <b-cousson@ti.com>
CC: <linux@arm.linux.org.uk>, <rnayak@ti.com>, <balbi@ti.com>, <rogerq@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] ARM: dts: omap4-panda: Provide PHY clock information
Date: Tue, 19 Mar 2013 16:27:00 +0200
Message-ID: <1363703220-4777-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363703220-4777-1-git-send-email-rogerq@ti.com>
References: <1363703220-4777-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB PHY needs AUXCLK3 to operate. Provide this information
in the device tree.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap4-panda.dts |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
index cfc7683..2cd369b 100644
--- a/arch/arm/boot/dts/omap4-panda.dts
+++ b/arch/arm/boot/dts/omap4-panda.dts
@@ -85,6 +85,8 @@
 		compatible = "usb-nop-xceiv";
 		reset-supply = <&hsusb1_reset>;
 		vcc-supply = <&hsusb1_power>;
+		clocks = <&aux_clks 3>;
+		clock-names = "main_clk";
 		clock-frequency = <19200000>;
 	};
 };
-- 
1.7.4.1

