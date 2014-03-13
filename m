Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaCMUgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:36:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43342 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaCMUgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:36:15 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Rob Herring <robh@kernel.org>,
        Tero Kristo <t-kristo@ti.com>, Nishanth Menon <nm@ti.com>,
        Suman Anna <s-anna@ti.com>, Felipe Balbi <balbi@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [RFC 1/5] ARM: dts: am33xx: Add clock nodes for timer1 and timer2
Date: Thu, 13 Mar 2014 15:35:15 -0500
Message-ID: <1394742919-32163-2-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394742919-32163-1-git-send-email-joelf@ti.com>
References: <1394742919-32163-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 6d95d3d..4e6c959 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -347,6 +347,7 @@
 
 		timer1: timer@44e31000 {
 			compatible = "ti,am335x-timer-1ms";
+			clocks = <&timer1_fck>;
 			reg = <0x44e31000 0x400>;
 			interrupts = <67>;
 			ti,hwmods = "timer1";
@@ -355,6 +356,7 @@
 
 		timer2: timer@48040000 {
 			compatible = "ti,am335x-timer";
+			clocks = <&timer2_fck>;
 			reg = <0x48040000 0x400>;
 			interrupts = <68>;
 			ti,hwmods = "timer2";
-- 
1.7.9.5

