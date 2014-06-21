Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934794AbaFULFB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 07:05:01 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:53026 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934748AbaFULE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 07:04:57 -0400
From: Alexander Bersenev <bay@hackerdom.ru>
To: linux-sunxi@googlegroups.com, david@hardeman.nu,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
        james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, pawel.moll@arm.com,
        rdunlap@infradead.org, robh+dt@kernel.org, sean@mess.org,
        srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: Alexander Bersenev <bay@hackerdom.ru>
Subject: [PATCH v10 5/5] ARM: sunxi: Enable IR controller on cubieboard 2 and cubietruck in dts
Date: Sat, 21 Jun 2014 17:04:06 +0600
Message-Id: <1403348646-31091-6-git-send-email-bay@hackerdom.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403348646-31091-1-git-send-email-bay@hackerdom.ru>
References: <1403348646-31091-1-git-send-email-bay@hackerdom.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables two IR devices in dts:
- One IR device physically found on Cubieboard 2
- One IR device physically found on Cubietruck

Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>
---
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts |    6 ++++++
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts  |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
index a5ad945..a70f0b4 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
@@ -66,6 +66,12 @@
 			};
 		};
 
+		ir0: ir@01c21800 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&ir0_pins_a>;
+			status = "okay";
+		};
+
 		uart0: serial@01c28000 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&uart0_pins_a>;
diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
index b87fea9..96639d5 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
@@ -100,6 +100,12 @@
 			status = "okay";
 		};
 
+		ir0: ir@01c21800 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&ir0_pins_a>;
+			status = "okay";
+		};
+
 		uart0: serial@01c28000 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&uart0_pins_a>;
-- 
1.7.1

