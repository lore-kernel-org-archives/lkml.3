Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaIQIYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:24:23 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64420 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbaIQIYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:24:18 -0400
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: shawn.guo@freescale.com
Cc: stefan@agner.ch, B38611@freescale.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@kernel.org, linux-iio@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH 1/2] ARM: dts: vf610-colibri: Add ADC support
Date: Wed, 17 Sep 2014 13:53:16 +0530
Message-Id: <1015e874d5b13795e38069402a66b4798d79b632.1410873422.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1410873422.git.maitysanchayan@gmail.com>
References: <cover.1410873422.git.maitysanchayan@gmail.com>
In-Reply-To: <cover.1410873422.git.maitysanchayan@gmail.com>
References: <cover.1410873422.git.maitysanchayan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable ADC support for Colibri VF61 modules

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
---
 arch/arm/boot/dts/vf610-colibri.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
index 0cd8343..275ebec 100644
--- a/arch/arm/boot/dts/vf610-colibri.dtsi
+++ b/arch/arm/boot/dts/vf610-colibri.dtsi
@@ -69,6 +69,16 @@
 	status = "okay";
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
 &iomuxc {
 	vf610-colibri {
 		pinctrl_esdhc1: esdhc1grp {
-- 
1.7.9.5

