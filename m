Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3A2VAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 16:00:14 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:59341 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3A2VAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 16:00:11 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dove: convert serial DT nodes to clocks property
Date: Tue, 29 Jan 2013 21:59:46 +0100
Message-Id: <1359493186-25589-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_serial now has support for using clocks property and we have
a DT clock provider. This patch replaces the hard coded clock-frequency
property with a clocks phandle to tclk.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 42eac1f..7b52463 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -55,7 +55,7 @@
 			reg = <0x12000 0x100>;
 			reg-shift = <2>;
 			interrupts = <7>;
-			clock-frequency = <166666667>;
+			clocks = <&core_clk 0>;
 			status = "disabled";
 		};
 
@@ -64,7 +64,7 @@
 			reg = <0x12100 0x100>;
 			reg-shift = <2>;
 			interrupts = <8>;
-			clock-frequency = <166666667>;
+			clocks = <&core_clk 0>;
 			status = "disabled";
 		};
 
@@ -73,7 +73,7 @@
 			reg = <0x12000 0x100>;
 			reg-shift = <2>;
 			interrupts = <9>;
-			clock-frequency = <166666667>;
+			clocks = <&core_clk 0>;
 			status = "disabled";
 		};
 
@@ -82,7 +82,7 @@
 			reg = <0x12100 0x100>;
 			reg-shift = <2>;
 			interrupts = <10>;
-			clock-frequency = <166666667>;
+			clocks = <&core_clk 0>;
 			status = "disabled";
 		};
 
-- 
1.7.10.4

