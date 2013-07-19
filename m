Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965878Ab3GSF3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:29:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965827Ab3GSF1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:27:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [ 64/72] ARM: dts: imx: cpus/cpu nodes dts updates
Date: Thu, 18 Jul 2013 22:26:21 -0700
Message-Id: <20130719052604.242601344@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

commit 7925e89f54fc49bcd1e73f0a65c4a3eb35b9cfb1 upstream.

This patch updates the in-kernel dts files according to the latest cpus
and cpu bindings updates for ARM.

Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx23.dtsi  |    8 ++++++--
 arch/arm/boot/dts/imx28.dtsi  |    8 ++++++--
 arch/arm/boot/dts/imx6dl.dtsi |    2 ++
 arch/arm/boot/dts/imx6q.dtsi  |    4 ++++
 4 files changed, 18 insertions(+), 4 deletions(-)

--- a/arch/arm/boot/dts/imx23.dtsi
+++ b/arch/arm/boot/dts/imx23.dtsi
@@ -23,8 +23,12 @@
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
 
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -32,8 +32,12 @@
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
 
--- a/arch/arm/boot/dts/imx6dl.dtsi
+++ b/arch/arm/boot/dts/imx6dl.dtsi
@@ -18,12 +18,14 @@
 
 		cpu@0 {
 			compatible = "arm,cortex-a9";
+			device_type = "cpu";
 			reg = <0>;
 			next-level-cache = <&L2>;
 		};
 
 		cpu@1 {
 			compatible = "arm,cortex-a9";
+			device_type = "cpu";
 			reg = <1>;
 			next-level-cache = <&L2>;
 		};
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -18,6 +18,7 @@
 
 		cpu@0 {
 			compatible = "arm,cortex-a9";
+			device_type = "cpu";
 			reg = <0>;
 			next-level-cache = <&L2>;
 			operating-points = <
@@ -39,18 +40,21 @@
 
 		cpu@1 {
 			compatible = "arm,cortex-a9";
+			device_type = "cpu";
 			reg = <1>;
 			next-level-cache = <&L2>;
 		};
 
 		cpu@2 {
 			compatible = "arm,cortex-a9";
+			device_type = "cpu";
 			reg = <2>;
 			next-level-cache = <&L2>;
 		};
 
 		cpu@3 {
 			compatible = "arm,cortex-a9";
+			device_type = "cpu";
 			reg = <3>;
 			next-level-cache = <&L2>;
 		};


