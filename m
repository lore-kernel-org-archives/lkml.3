Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3DLKhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 06:37:05 -0400
Received: from mail.abilis.ch ([195.70.19.74]:23818 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab3DLKhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 06:37:03 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH] ARC: [TB10x] Adapt device tree to new compatible string
Date: Fri, 12 Apr 2013 12:36:29 +0200
Message-Id: <1365762989-31638-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <5167D7E4.9030206@free-electrons.com>
References: <5167D7E4.9030206@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original device tree was written using a slightly different
implementation of the fixed-factor-clock device tree binding. The
compatible string must be modified in order to be compatible with the
new implementation.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 arch/arc/boot/dts/abilis_tb10x.dtsi |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/boot/dts/abilis_tb10x.dtsi b/arch/arc/boot/dts/abilis_tb10x.dtsi
index 6d80d9c..a6139fc 100644
--- a/arch/arc/boot/dts/abilis_tb10x.dtsi
+++ b/arch/arc/boot/dts/abilis_tb10x.dtsi
@@ -53,13 +53,13 @@
 			clock-output-names = "pll0";
 		};
 		cpu_clk: clkdiv_cpu {
-			compatible = "fixed-factor-clkdiv";
+			compatible = "fixed-factor-clock";
 			#clock-cells = <0>;
 			clocks = <&pll0>;
 			clock-output-names = "cpu_clk";
 		};
 		ahb_clk: clkdiv_ahb {
-			compatible = "fixed-factor-clkdiv";
+			compatible = "fixed-factor-clock";
 			#clock-cells = <0>;
 			clocks = <&pll0>;
 			clock-output-names = "ahb_clk";
-- 
1.7.1

