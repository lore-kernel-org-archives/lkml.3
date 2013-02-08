Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946589Ab3BHNiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 08:38:46 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1940 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946022Ab3BHNin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 08:38:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 08 Feb 2013 05:35:17 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 08/10] ARM: dt: Add references to tegra_car clocks
Date: Fri, 8 Feb 2013 15:36:40 +0200
Message-ID: <1360330602-30472-9-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1360330602-30472-1-git-send-email-pdeschrijver@nvidia.com>
References: <1360330602-30472-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add references to tegra_car clocks for the basic device nodes.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/boot/dts/tegra114.dtsi |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index 96a8235..6b0a01e 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -24,10 +24,11 @@
 			      0 42 0x04
 			      0 121 0x04
 			      0 122 0x04>;
+		clocks = <&tegra_car 5>;
 	};
 
 	tegra_car: clock {
-		compatible = "nvidia,tegra114-car, nvidia,tegra30-car";
+		compatible = "nvidia,tegra114-car";
 		reg = <0x60006000 0x1000>;
 		#clock-cells = <1>;
 	};
@@ -43,6 +44,7 @@
 		reg-shift = <2>;
 		interrupts = <0 36 0x04>;
 		status = "disabled";
+		clocks = <&tegra_car 6>;
 	};
 
 	serial@70006040 {
@@ -51,6 +53,7 @@
 		reg-shift = <2>;
 		interrupts = <0 37 0x04>;
 		status = "disabled";
+		clocks = <&tegra_car 192>;
 	};
 
 	serial@70006200 {
@@ -59,6 +62,7 @@
 		reg-shift = <2>;
 		interrupts = <0 46 0x04>;
 		status = "disabled";
+		clocks = <&tegra_car 55>;
 	};
 
 	serial@70006300 {
@@ -67,12 +71,14 @@
 		reg-shift = <2>;
 		interrupts = <0 90 0x04>;
 		status = "disabled";
+		clocks = <&tegra_car 65>;
 	};
 
 	rtc {
 		compatible = "nvidia,tegra114-rtc", "nvidia,tegra20-rtc";
 		reg = <0x7000e000 0x100>;
 		interrupts = <0 2 0x04>;
+		clocks = <&tegra_car 4>;
 	};
 
 	pmc {
-- 
1.7.1

