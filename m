Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3GBKyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:54:25 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:45682 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3GBKyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:54:23 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] ARM: remove dmacap,memset from Device tree binding
Date: Tue,  2 Jul 2013 12:54:12 +0200
Message-Id: <1372762453-12018-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1372762453-12018-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1372762453-12018-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA_MEMSET support has been removed, so update the device tree files
and corresponding binding documentation for Marvell SoCs.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk> 
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com> 
Cc: devicetree-discuss@lists.ozlabs.org 
Cc: linux-kernel@vger.kernel.org 
Cc: linux-arm-kernel@lists.infradead.org 
---
 Documentation/devicetree/bindings/dma/mv-xor.txt |    2 --
 arch/arm/boot/dts/armada-370.dtsi                |    2 --
 arch/arm/boot/dts/armada-xp.dtsi                 |    2 --
 arch/arm/boot/dts/dove.dtsi                      |    2 --
 arch/arm/boot/dts/kirkwood.dtsi                  |    2 --
 arch/arm/boot/dts/orion5x.dtsi                   |    1 -
 6 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/mv-xor.txt b/Documentation/devicetree/bindings/dma/mv-xor.txt
index 7c6cb7f..68f7004 100644
--- a/Documentation/devicetree/bindings/dma/mv-xor.txt
+++ b/Documentation/devicetree/bindings/dma/mv-xor.txt
@@ -14,7 +14,6 @@ properties:
 
 And the following optional properties:
 - dmacap,memcpy to indicate that the XOR channel is capable of memcpy operations
-- dmacap,memset to indicate that the XOR channel is capable of memset operations
 - dmacap,xor to indicate that the XOR channel is capable of xor operations
 
 Example:
@@ -35,6 +34,5 @@ xor@d0060900 {
 	      interrupts = <52>;
 	      dmacap,memcpy;
 	      dmacap,xor;
-	      dmacap,memset;
 	};
 };
diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
index fa3dfc6..a315ad1 100644
--- a/arch/arm/boot/dts/armada-370.dtsi
+++ b/arch/arm/boot/dts/armada-370.dtsi
@@ -132,7 +132,6 @@
 					interrupts = <52>;
 					dmacap,memcpy;
 					dmacap,xor;
-					dmacap,memset;
 				};
 			};
 
@@ -151,7 +150,6 @@
 					interrupts = <95>;
 					dmacap,memcpy;
 					dmacap,xor;
-					dmacap,memset;
 				};
 			};
 
diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
index 416eb94..4b3dd56 100644
--- a/arch/arm/boot/dts/armada-xp.dtsi
+++ b/arch/arm/boot/dts/armada-xp.dtsi
@@ -114,7 +114,6 @@
 					interrupts = <52>;
 					dmacap,memcpy;
 					dmacap,xor;
-					dmacap,memset;
 				};
 			};
 
@@ -134,7 +133,6 @@
 					interrupts = <95>;
 					dmacap,memcpy;
 					dmacap,xor;
-					dmacap,memset;
 				};
 			};
 
diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 6cab468..2cef34f 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -232,7 +232,6 @@
 
 			channel1 {
 				interrupts = <40>;
-				dmacap,memset;
 				dmacap,memcpy;
 				dmacap,xor;
 			};
@@ -253,7 +252,6 @@
 
 			channel1 {
 				interrupts = <43>;
-				dmacap,memset;
 				dmacap,memcpy;
 				dmacap,xor;
 			};
diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
index 9809fc1..078637c 100644
--- a/arch/arm/boot/dts/kirkwood.dtsi
+++ b/arch/arm/boot/dts/kirkwood.dtsi
@@ -126,7 +126,6 @@
 			      interrupts = <6>;
 			      dmacap,memcpy;
 			      dmacap,xor;
-			      dmacap,memset;
 			};
 		};
 
@@ -146,7 +145,6 @@
 			      interrupts = <8>;
 			      dmacap,memcpy;
 			      dmacap,xor;
-			      dmacap,memset;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/orion5x.dtsi b/arch/arm/boot/dts/orion5x.dtsi
index 892c64e..f82ece7 100644
--- a/arch/arm/boot/dts/orion5x.dtsi
+++ b/arch/arm/boot/dts/orion5x.dtsi
@@ -120,7 +120,6 @@
 			      interrupts = <31>;
 			      dmacap,memcpy;
 			      dmacap,xor;
-			      dmacap,memset;
 			};
 		};
 
-- 
1.7.2.5

