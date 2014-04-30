Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbaD3M5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:57:53 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:46866 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758960AbaD3M5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:57:03 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/15] ARM: dts: kirkwood: set Guruplug ethernet PHY compatible
Date: Wed, 30 Apr 2014 14:56:41 +0200
Message-Id: <1398862602-29595-15-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ethernet PHY compatible shall be "ethernet-phy-ieee802.3-c22" and
"ethernet-phy-idAAAA.BBBB" if PHY OUI id is known. We know it for
the PHY found on Guruplug, so set it accordingly.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts b/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
index 871a5f8afb01..f6f15e2910ed 100644
--- a/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
+++ b/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
@@ -101,12 +101,16 @@
 	status = "okay";
 
 	ethphy0: ethernet-phy@0 {
-		compatible = "marvell,88e1121";
+		/* Marvell 88E1121R */
+		compatible = "ethernet-phy-id0141.0cb0",
+		             "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 	};
 
 	ethphy1: ethernet-phy@1 {
-		compatible = "marvell,88e1121";
+		/* Marvell 88E1121R */
+		compatible = "ethernet-phy-id0141.0cb0",
+		             "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
 	};
 };
-- 
1.9.1

