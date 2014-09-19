Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbaISL0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:26:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54205 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbaISL0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:26:50 -0400
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: shawn.guo@freescale.com
Cc: stefan@agner.ch, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH v2] ARM: dts: vf610-colibri: Add ADC support
Date: Fri, 19 Sep 2014 16:56:13 +0530
Message-Id: <a0ecfce3f97fb6684657ae76b89f38108fcdf68f.1411122224.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1411122224.git.maitysanchayan@gmail.com>
References: <cover.1411122224.git.maitysanchayan@gmail.com>
In-Reply-To: <cover.1411122224.git.maitysanchayan@gmail.com>
References: <cover.1411122224.git.maitysanchayan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable ADC support for Colibri VF61 modules

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
---
 arch/arm/boot/dts/vf610-colibri.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
index 0cd8343..6fd099e 100644
--- a/arch/arm/boot/dts/vf610-colibri.dtsi
+++ b/arch/arm/boot/dts/vf610-colibri.dtsi
@@ -27,6 +27,16 @@
 
 };
 
+&adc0 {
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&adc1 {
+	pinctrl-names = "default";
+	status = "okay";
+};
+
 &esdhc1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_esdhc1>;
-- 
1.7.9.5

