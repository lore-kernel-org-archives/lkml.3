Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbaGZT11 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:27:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbaGZTXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Vasut <marex@denx.de>, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3.15 106/109] ARM: dts: imx: Add alias for ethernet controller
Date: Sat, 26 Jul 2014 12:03:08 -0700
Message-Id: <20140726190227.040647041@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

commit 22970070e027cbbb9b2878f8f7c31d0d7f29e94d upstream.

Add alias for FEC ethernet on i.MX to allow bootloaders (like U-Boot)
patch-in the MAC address for FEC using this alias.

Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx25.dtsi   |    1 +
 arch/arm/boot/dts/imx27.dtsi   |    1 +
 arch/arm/boot/dts/imx35.dtsi   |    1 +
 arch/arm/boot/dts/imx50.dtsi   |    1 +
 arch/arm/boot/dts/imx51.dtsi   |    1 +
 arch/arm/boot/dts/imx53.dtsi   |    1 +
 arch/arm/boot/dts/imx6qdl.dtsi |    1 +
 arch/arm/boot/dts/imx6sl.dtsi  |    1 +
 8 files changed, 8 insertions(+)

--- a/arch/arm/boot/dts/imx25.dtsi
+++ b/arch/arm/boot/dts/imx25.dtsi
@@ -14,6 +14,7 @@
 
 / {
 	aliases {
+		ethernet0 = &fec;
 		gpio0 = &gpio1;
 		gpio1 = &gpio2;
 		gpio2 = &gpio3;
--- a/arch/arm/boot/dts/imx27.dtsi
+++ b/arch/arm/boot/dts/imx27.dtsi
@@ -16,6 +16,7 @@
 
 / {
 	aliases {
+		ethernet0 = &fec;
 		gpio0 = &gpio1;
 		gpio1 = &gpio2;
 		gpio2 = &gpio3;
--- a/arch/arm/boot/dts/imx35.dtsi
+++ b/arch/arm/boot/dts/imx35.dtsi
@@ -13,6 +13,7 @@
 
 / {
 	aliases {
+		ethernet0 = &fec;
 		gpio0 = &gpio1;
 		gpio1 = &gpio2;
 		gpio2 = &gpio3;
--- a/arch/arm/boot/dts/imx50.dtsi
+++ b/arch/arm/boot/dts/imx50.dtsi
@@ -17,6 +17,7 @@
 
 / {
 	aliases {
+		ethernet0 = &fec;
 		gpio0 = &gpio1;
 		gpio1 = &gpio2;
 		gpio2 = &gpio3;
--- a/arch/arm/boot/dts/imx51.dtsi
+++ b/arch/arm/boot/dts/imx51.dtsi
@@ -19,6 +19,7 @@
 
 / {
 	aliases {
+		ethernet0 = &fec;
 		gpio0 = &gpio1;
 		gpio1 = &gpio2;
 		gpio2 = &gpio3;
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -18,6 +18,7 @@
 
 / {
 	aliases {
+		ethernet0 = &fec;
 		gpio0 = &gpio1;
 		gpio1 = &gpio2;
 		gpio2 = &gpio3;
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -16,6 +16,7 @@
 
 / {
 	aliases {
+		ethernet0 = &fec;
 		can0 = &can1;
 		can1 = &can2;
 		gpio0 = &gpio1;
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -14,6 +14,7 @@
 
 / {
 	aliases {
+		ethernet0 = &fec;
 		gpio0 = &gpio1;
 		gpio1 = &gpio2;
 		gpio2 = &gpio3;


