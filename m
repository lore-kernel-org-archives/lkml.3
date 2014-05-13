Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426AbaEMKp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:45:56 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759838AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mugunthan V N <mugunthanvnm@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 014/182] ARM: dts: am33xx: correcting dt node unit address for usb
Date: Tue, 13 May 2014 11:26:06 +0200
Message-Id: <4438a9ca9631f1ce6989de75c90ffd5dbd30a139.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mugunthan V N <mugunthanvnm@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8abcdd680d543fb582371e146e62ba9f2af8a816 upstream.

DT node's unit address should be its own register offset address to make it a
unique across the system. This patch corrects the incorrect USB entries with
correct register offset for unit address.

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/boot/dts/am33xx.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index f9c5da9c7fe1..e9b6775299d0 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -346,7 +346,7 @@
 			ti,hwmods = "usb_otg_hs";
 			status = "disabled";
 
-			ctrl_mod: control@44e10000 {
+			ctrl_mod: control@44e10620 {
 				compatible = "ti,am335x-usb-ctrl-module";
 				reg = <0x44e10620 0x10
 					0x44e10648 0x4>;
@@ -449,7 +449,7 @@
 					"tx14", "tx15";
 			};
 
-			cppi41dma: dma-controller@07402000 {
+			cppi41dma: dma-controller@47402000 {
 				compatible = "ti,am3359-cppi41";
 				reg =  <0x47400000 0x1000
 					0x47402000 0x1000
-- 
1.9.3

