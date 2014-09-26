Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaIZMhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:37:54 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:51358 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaIZMhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:37:53 -0400
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: shawn.guo@freescale.com
Cc: stefan@agner.ch, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH v3] ARM: dts: vf610-colibri: Add ADC support
Date: Fri, 26 Sep 2014 18:07:22 +0530
Message-Id: <beb70de8c539e52a60db95edebf85abda0ee2634.1411734906.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable ADC support for Colibri VF61 modules

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
---
 arch/arm/boot/dts/vf610-colibri.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
index 0cd8343..c8bf6e2 100644
--- a/arch/arm/boot/dts/vf610-colibri.dtsi
+++ b/arch/arm/boot/dts/vf610-colibri.dtsi
@@ -27,6 +27,14 @@
 
 };
 
+&adc0 {
+	status = "okay";
+};
+
+&adc1 {
+	status = "okay";
+};
+
 &esdhc1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_esdhc1>;
-- 
1.7.9.5

