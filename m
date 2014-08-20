Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaHTP5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:57:22 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:35490 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaHTP5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:57:20 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 1/3] ARM: zynq: DT: Fix Ethernet phy modes
Date: Wed, 20 Aug 2014 08:56:57 -0700
Message-Id: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The used PHYs should be qualified as 'rgmii-id' instead of just 'rgmii'.
For the Zed board this seems to make a difference between working and
broken Ethernet.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/boot/dts/zynq-zc702.dts | 2 +-
 arch/arm/boot/dts/zynq-zc706.dts | 2 +-
 arch/arm/boot/dts/zynq-zed.dts   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index 835c3089c61c..30bcfe20f0bc 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -35,7 +35,7 @@
 
 &gem0 {
 	status = "okay";
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &i2c0 {
diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
index 4cc9913078cd..3d9cb023e158 100644
--- a/arch/arm/boot/dts/zynq-zc706.dts
+++ b/arch/arm/boot/dts/zynq-zc706.dts
@@ -32,7 +32,7 @@
 
 &gem0 {
 	status = "okay";
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &i2c0 {
diff --git a/arch/arm/boot/dts/zynq-zed.dts b/arch/arm/boot/dts/zynq-zed.dts
index 82d7ef1a9a9c..42deb1b7dbc8 100644
--- a/arch/arm/boot/dts/zynq-zed.dts
+++ b/arch/arm/boot/dts/zynq-zed.dts
@@ -32,7 +32,7 @@
 
 &gem0 {
 	status = "okay";
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &sdhci0 {
-- 
2.0.1.1.gfbfc394

