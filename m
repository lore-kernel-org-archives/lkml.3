Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaEDPlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaEDPlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, Mugunthan V N <mugunthanvnm@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.14 012/158] ARM: dts: am33xx: correcting dt node unit address for usb
Date: Sun,  4 May 2014 11:38:41 -0400
Message-Id: <20140504154031.690140742@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mugunthan V N <mugunthanvnm@ti.com>

commit 8abcdd680d543fb582371e146e62ba9f2af8a816 upstream.

DT node's unit address should be its own register offset address to make it a
unique across the system. This patch corrects the incorrect USB entries with
correct register offset for unit address.

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/am33xx.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -448,7 +448,7 @@
 			ti,hwmods = "usb_otg_hs";
 			status = "disabled";
 
-			usb_ctrl_mod: control@44e10000 {
+			usb_ctrl_mod: control@44e10620 {
 				compatible = "ti,am335x-usb-ctrl-module";
 				reg = <0x44e10620 0x10
 					0x44e10648 0x4>;
@@ -551,7 +551,7 @@
 					"tx14", "tx15";
 			};
 
-			cppi41dma: dma-controller@07402000 {
+			cppi41dma: dma-controller@47402000 {
 				compatible = "ti,am3359-cppi41";
 				reg =  <0x47400000 0x1000
 					0x47402000 0x1000


