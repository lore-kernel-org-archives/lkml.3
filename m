Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaLPSWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:22:21 -0500
Received: from h1943130.stratoserver.net ([81.169.133.216]:50802 "EHLO
	studio-punkt.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaLPSWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:22:20 -0500
Date: Tue, 16 Dec 2014 19:22:18 +0100
From: Evgeni Dobrev <evgeni@studio-punkt.com>
To: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: [PATCH v2 1/1] ARM: dts: kirkwood: enable phy driver for SATA
 controller on 88f6192
Message-ID: <20141216182217.GA20696@anne>
References: <20141215203724.GA22936@anne>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215203724.GA22936@anne>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the phy drivers for the SATA controller on Marvell's 88f6192.
Without them it is not possible to use SATA drives attached to this processor.

Signed-off-by: Evgeni Dobrev <evgeni@studio-punkt.com>
---
 arch/arm/boot/dts/kirkwood-6192.dtsi |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/kirkwood-6192.dtsi b/arch/arm/boot/dts/kirkwood-6192.dtsi
index dd81508..9e6e9e2 100644
--- a/arch/arm/boot/dts/kirkwood-6192.dtsi
+++ b/arch/arm/boot/dts/kirkwood-6192.dtsi
@@ -66,6 +66,8 @@
 			interrupts = <21>;
 			clocks = <&gate_clk 14>, <&gate_clk 15>;
 			clock-names = "0", "1";
+			phys = <&sata_phy0>, <&sata_phy1>;
+			phy-names = "port0", "port1";
 			status = "disabled";
 		};
 
-- 
1.7.10.4

