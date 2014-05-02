Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaEBPoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:44:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44069 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbaEBPoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:44:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mugunthan V N <mugunthanvnm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 046/151] ARM: dts: am33xx: correcting dt node unit address for usb
Date: Fri,  2 May 2014 08:37:14 -0700
Message-Id: <1399045139-4531-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/boot/dts/am33xx.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index f6d8ffe..bb98f30 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -422,7 +422,7 @@
 			ti,hwmods = "usb_otg_hs";
 			status = "disabled";
 
-			usb_ctrl_mod: control@44e10000 {
+			usb_ctrl_mod: control@44e10620 {
 				compatible = "ti,am335x-usb-ctrl-module";
 				reg = <0x44e10620 0x10
 					0x44e10648 0x4>;
@@ -525,7 +525,7 @@
 					"tx14", "tx15";
 			};
 
-			cppi41dma: dma-controller@07402000 {
+			cppi41dma: dma-controller@47402000 {
 				compatible = "ti,am3359-cppi41";
 				reg =  <0x47400000 0x1000
 					0x47402000 0x1000
-- 
1.9.1

