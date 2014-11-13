Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934151AbaKMTfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:35:54 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:59783 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934012AbaKMTfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:35:38 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Carlo Caione <carlo@caione.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jerry Cao <jerry.cao@amlogic.com>, Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v3 3/3] ARM: dts: meson: add I2C controller nodes
Date: Thu, 13 Nov 2014 20:32:03 +0100
Message-Id: <1415907123-4318-4-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415907123-4318-1-git-send-email-b.galvani@gmail.com>
References: <1415907123-4318-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nodes for I2C controllers A,B,AO, which are available in both
Meson6 and Meson8.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 arch/arm/boot/dts/meson.dtsi | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/meson.dtsi b/arch/arm/boot/dts/meson.dtsi
index e6539ea..4f16aee 100644
--- a/arch/arm/boot/dts/meson.dtsi
+++ b/arch/arm/boot/dts/meson.dtsi
@@ -106,5 +106,35 @@
 			clocks = <&clk81>;
 			status = "disabled";
 		};
+
+		i2c_AO: i2c@c8100500 {
+			compatible = "amlogic,meson6-i2c";
+			reg = <0xc8100500 0x20>;
+			interrupts = <0 92 1>;
+			clocks = <&clk81>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+		};
+
+		i2c_A: i2c@c1108500 {
+			compatible = "amlogic,meson6-i2c";
+			reg = <0xc1108500 0x20>;
+			interrupts = <0 21 1>;
+			clocks = <&clk81>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+		};
+
+		i2c_B: i2c@c11087c0 {
+			compatible = "amlogic,meson6-i2c";
+			reg = <0xc11087c0 0x20>;
+			interrupts = <0 128 1>;
+			clocks = <&clk81>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+		};
 	};
 }; /* end of / */
-- 
1.9.1

