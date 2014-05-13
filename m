Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401AbaEMKLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:11:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933358AbaEMKLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:05 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Leigh Brown <leigh@solinno.co.uk>,
        Tony Lindgren <tony@atomide.com>, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 122/182] ARM: dts: am335x: update USB DT references
Date: Tue, 13 May 2014 11:27:54 +0200
Message-Id: <6bd2fb033b2c005db1b318d2f09e4796b0487ff5.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leigh Brown <leigh@solinno.co.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a2f8d6b303213a98436455aece7e14cdd1240629 upstream.

In "ARM: dts: am33xx: correcting dt node unit address for usb", the
usb_ctrl_mod and cppi41dma nodes were updated with the correct register
addresses.  However, the dts files that reference these nodes were not
updated, and those devices are no longer being enabled.

This patch corrects the references for the affected dts files.

Signed-off-by: Leigh Brown <leigh@solinno.co.uk>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/boot/dts/am335x-bone-common.dtsi | 4 ++--
 arch/arm/boot/dts/am335x-evm.dts          | 4 ++--
 arch/arm/boot/dts/am335x-evmsk.dts        | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
index 2f66deda9f5c..e6e952e32117 100644
--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -120,7 +120,7 @@
 		musb: usb@47400000 {
 			status = "okay";
 
-			control@44e10000 {
+			control@44e10620 {
 				status = "okay";
 			};
 
@@ -141,7 +141,7 @@
 				dr_mode = "host";
 			};
 
-			dma-controller@07402000  {
+			dma-controller@47402000  {
 				status = "okay";
 			};
 		};
diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index e8ec8756e498..b2f476911e13 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -174,7 +174,7 @@
 		musb: usb@47400000 {
 			status = "okay";
 
-			control@44e10000 {
+			control@44e10620 {
 				status = "okay";
 			};
 
@@ -195,7 +195,7 @@
 				dr_mode = "host";
 			};
 
-			dma-controller@07402000  {
+			dma-controller@47402000  {
 				status = "okay";
 			};
 		};
diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index 4f339fa91c57..521d92afc78a 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -211,7 +211,7 @@
 		musb: usb@47400000 {
 			status = "okay";
 
-			control@44e10000 {
+			control@44e10620 {
 				status = "okay";
 			};
 
-- 
1.9.3

