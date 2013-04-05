Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162857Ab3DEUYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:24:52 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:40703 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162825Ab3DEUYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:24:32 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v2 8/9] arm: dts: mvebu: fix cpus section indentation
Date: Fri,  5 Apr 2013 22:24:03 +0200
Message-Id: <1365193444-13441-9-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com>
References: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 arch/arm/boot/dts/armada-xp-mv78230.dtsi |   28 ++++++++--------
 arch/arm/boot/dts/armada-xp-mv78260.dtsi |   28 ++++++++--------
 arch/arm/boot/dts/armada-xp-mv78460.dtsi |   54 +++++++++++++++---------------
 3 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/arch/arm/boot/dts/armada-xp-mv78230.dtsi b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
index f0d38fb..392f118 100644
--- a/arch/arm/boot/dts/armada-xp-mv78230.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
@@ -25,22 +25,22 @@
 	};
 
 	cpus {
-	    #address-cells = <1>;
-	    #size-cells = <0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
-	    cpu@0 {
-		device_type = "cpu";
-		compatible = "marvell,sheeva-v7";
-		reg = <0>;
-		clocks = <&cpuclk 0>;
-	    };
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "marvell,sheeva-v7";
+			reg = <0>;
+			clocks = <&cpuclk 0>;
+		};
 
-	    cpu@1 {
-		device_type = "cpu";
-		compatible = "marvell,sheeva-v7";
-		reg = <1>;
-		clocks = <&cpuclk 1>;
-	    };
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "marvell,sheeva-v7";
+			reg = <1>;
+			clocks = <&cpuclk 1>;
+		};
 	};
 
 	soc {
diff --git a/arch/arm/boot/dts/armada-xp-mv78260.dtsi b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
index 2621bda..8fb7fea 100644
--- a/arch/arm/boot/dts/armada-xp-mv78260.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
@@ -26,22 +26,22 @@
 	};
 
 	cpus {
-	    #address-cells = <1>;
-	    #size-cells = <0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
-	    cpu@0 {
-		device_type = "cpu";
-		compatible = "marvell,sheeva-v7";
-		reg = <0>;
-		clocks = <&cpuclk 0>;
-	    };
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "marvell,sheeva-v7";
+			reg = <0>;
+			clocks = <&cpuclk 0>;
+		};
 
-	    cpu@1 {
-		device_type = "cpu";
-		compatible = "marvell,sheeva-v7";
-		reg = <1>;
-		clocks = <&cpuclk 1>;
-	    };
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "marvell,sheeva-v7";
+			reg = <1>;
+			clocks = <&cpuclk 1>;
+		};
 	};
 
 	soc {
diff --git a/arch/arm/boot/dts/armada-xp-mv78460.dtsi b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
index ccb95ff..fa665cb 100644
--- a/arch/arm/boot/dts/armada-xp-mv78460.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
@@ -27,36 +27,36 @@
 
 
 	cpus {
-	    #address-cells = <1>;
-	    #size-cells = <0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
-	    cpu@0 {
-		device_type = "cpu";
-		compatible = "marvell,sheeva-v7";
-		reg = <0>;
-		clocks = <&cpuclk 0>;
-	    };
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "marvell,sheeva-v7";
+			reg = <0>;
+			clocks = <&cpuclk 0>;
+		};
 
-	    cpu@1 {
-		device_type = "cpu";
-		compatible = "marvell,sheeva-v7";
-		reg = <1>;
-		clocks = <&cpuclk 1>;
-	    };
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "marvell,sheeva-v7";
+			reg = <1>;
+			clocks = <&cpuclk 1>;
+		};
 
-	    cpu@2 {
-		device_type = "cpu";
-		compatible = "marvell,sheeva-v7";
-		reg = <2>;
-		clocks = <&cpuclk 2>;
-	    };
+		cpu@2 {
+			device_type = "cpu";
+			compatible = "marvell,sheeva-v7";
+			reg = <2>;
+			clocks = <&cpuclk 2>;
+		};
 
-	    cpu@3 {
-		device_type = "cpu";
-		compatible = "marvell,sheeva-v7";
-		reg = <3>;
-		clocks = <&cpuclk 3>;
-	    };
+		cpu@3 {
+			device_type = "cpu";
+			compatible = "marvell,sheeva-v7";
+			reg = <3>;
+			clocks = <&cpuclk 3>;
+		};
 	};
 
 	soc {
@@ -114,4 +114,4 @@
 			};
 		};
 	};
- };
+};
-- 
1.7.9.5

