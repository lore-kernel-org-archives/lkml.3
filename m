Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab3IYAQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:16:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab3IYAPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:15:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [ 011/110] ARM: dts: at91: cpus/cpu node dts updates
Date: Tue, 24 Sep 2013 17:14:09 -0700
Message-Id: <20130925001324.627549713@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

commit e757a6ee3e6fc1583b12b156588e8583f798d35c upstream.

This patch updates the in-kernel dts files according to the latest cpus
and cpu bindings updates for ARM.

Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/at91rm9200.dtsi  |    6 +++++-
 arch/arm/boot/dts/at91sam9260.dtsi |    8 ++++++--
 arch/arm/boot/dts/at91sam9263.dtsi |    8 ++++++--
 arch/arm/boot/dts/at91sam9g45.dtsi |    8 ++++++--
 arch/arm/boot/dts/at91sam9n12.dtsi |    8 ++++++--
 arch/arm/boot/dts/at91sam9x5.dtsi  |    8 ++++++--
 arch/arm/boot/dts/sama5d3.dtsi     |    2 ++
 7 files changed, 37 insertions(+), 11 deletions(-)

--- a/arch/arm/boot/dts/at91rm9200.dtsi
+++ b/arch/arm/boot/dts/at91rm9200.dtsi
@@ -35,8 +35,12 @@
 		ssc2 = &ssc2;
 	};
 	cpus {
-		cpu@0 {
+		#address-cells = <0>;
+		#size-cells = <0>;
+
+		cpu {
 			compatible = "arm,arm920t";
+			device_type = "cpu";
 		};
 	};
 
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -32,8 +32,12 @@
 		ssc0 = &ssc0;
 	};
 	cpus {
-		cpu@0 {
-			compatible = "arm,arm926ejs";
+		#address-cells = <0>;
+		#size-cells = <0>;
+
+		cpu {
+			compatible = "arm,arm926ej-s";
+			device_type = "cpu";
 		};
 	};
 
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -29,8 +29,12 @@
 		ssc1 = &ssc1;
 	};
 	cpus {
-		cpu@0 {
-			compatible = "arm,arm926ejs";
+		#address-cells = <0>;
+		#size-cells = <0>;
+
+		cpu {
+			compatible = "arm,arm926ej-s";
+			device_type = "cpu";
 		};
 	};
 
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -35,8 +35,12 @@
 		ssc1 = &ssc1;
 	};
 	cpus {
-		cpu@0 {
-			compatible = "arm,arm926ejs";
+		#address-cells = <0>;
+		#size-cells = <0>;
+
+		cpu {
+			compatible = "arm,arm926ej-s";
+			device_type = "cpu";
 		};
 	};
 
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -31,8 +31,12 @@
 		ssc0 = &ssc0;
 	};
 	cpus {
-		cpu@0 {
-			compatible = "arm,arm926ejs";
+		#address-cells = <0>;
+		#size-cells = <0>;
+
+		cpu {
+			compatible = "arm,arm926ej-s";
+			device_type = "cpu";
 		};
 	};
 
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -33,8 +33,12 @@
 		ssc0 = &ssc0;
 	};
 	cpus {
-		cpu@0 {
-			compatible = "arm,arm926ejs";
+		#address-cells = <0>;
+		#size-cells = <0>;
+
+		cpu {
+			compatible = "arm,arm926ej-s";
+			device_type = "cpu";
 		};
 	};
 
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -36,7 +36,9 @@
 	};
 	cpus {
 		cpu@0 {
+			device_type = "cpu";
 			compatible = "arm,cortex-a5";
+			reg = <0x0>;
 		};
 	};
 


