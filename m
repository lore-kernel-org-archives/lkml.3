Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbaISUQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:16:03 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59581 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbaISUOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:14:53 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] ARM: mvebu: armada-xp: Add GE0 pinctrl settings for GMII
Date: Fri, 19 Sep 2014 22:14:41 +0200
Message-Id: <1411157684-6991-6-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a GMII setting for GE0, add it to the common pinctrl node.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/armada-xp.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
index dfbcb10ad0db..327cace42242 100644
--- a/arch/arm/boot/dts/armada-xp.dtsi
+++ b/arch/arm/boot/dts/armada-xp.dtsi
@@ -74,6 +74,17 @@
 			pinctrl: pin-ctrl@18000 {
 				reg = <0x18000 0x38>;
 
+				pmx_ge0_gmii: pmx-ge0-gmii {
+					marvell,pins =
+					     "mpp0",  "mpp1",  "mpp2",  "mpp3",
+					     "mpp4",  "mpp5",  "mpp6",  "mpp7",
+					     "mpp8",  "mpp9",  "mpp10", "mpp11",
+					     "mpp12", "mpp13", "mpp14", "mpp15",
+					     "mpp16", "mpp17", "mpp18", "mpp19",
+					     "mpp20", "mpp21", "mpp22", "mpp23";
+					marvell,function = "ge0";
+				};
+
 				pmx_ge0_rgmii: pmx-ge0-rgmii {
 					marvell,pins =
 					     "mpp0", "mpp1", "mpp2", "mpp3",
-- 
2.0.0

