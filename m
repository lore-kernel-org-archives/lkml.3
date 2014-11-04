Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaKDNH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:07:29 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:42438 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbaKDNHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:07:25 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de
Cc: linus.walleij@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH 2/3] ARM: dts: vf610: enable USB misc/phy nodes where necessary
Date: Tue,  4 Nov 2014 14:07:09 +0100
Message-Id: <1415106430-6271-3-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415106430-6271-1-git-send-email-stefan@agner.ch>
References: <1415106430-6271-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since restructuring of the device tree files, the USB misc/phy
nodes are disabled by default. Hence we need to enable those
explicitly when USB is used.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf-colibri.dtsi | 16 ++++++++++++++++
 arch/arm/boot/dts/vf610-twr.dts   |  8 ++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/vf-colibri.dtsi b/arch/arm/boot/dts/vf-colibri.dtsi
index ab9616d7..2371760 100644
--- a/arch/arm/boot/dts/vf-colibri.dtsi
+++ b/arch/arm/boot/dts/vf-colibri.dtsi
@@ -75,6 +75,22 @@
 	status = "okay";
 };
 
+&usbmisc0 {
+	status = "okay";
+};
+
+&usbmisc1 {
+	status = "okay";
+};
+
+&usbphy0 {
+	status = "okay";
+};
+
+&usbphy1 {
+	status = "okay";
+};
+
 &iomuxc {
 	vf610-colibri {
 		pinctrl_gpio_ext: gpio_ext {
diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
index 793a376..a0f7621 100644
--- a/arch/arm/boot/dts/vf610-twr.dts
+++ b/arch/arm/boot/dts/vf610-twr.dts
@@ -294,6 +294,14 @@
 	status = "okay";
 };
 
+&usbmisc0 {
+	status = "okay";
+};
+
+&usbmisc1 {
+	status = "okay";
+};
+
 &usbphy0 {
 	status = "okay";
 };
-- 
2.1.3

