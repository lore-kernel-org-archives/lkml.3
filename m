Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3GXDmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:42:33 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50361 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3GXDmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:42:32 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: koba@kmckk.co.jp, Magnus Damm <magnus.damm@gmail.com>, horms@verge.net.au,
        linux-sh@vger.kernel.org
Date: Wed, 24 Jul 2013 12:42:40 +0900
Message-Id: <20130724034240.30596.52917.sendpatchset@w520>
Subject: [PATCH] ARM: shmobile: emev2: add PMU information to emev2.dtsi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add PMU information to emev2.dtsi. With this
included KZM9D DT reference may use the PMU.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/boot/dts/emev2.dtsi |    6 ++++++
 1 file changed, 6 insertions(+)

--- 0009/arch/arm/boot/dts/emev2.dtsi
+++ work/arch/arm/boot/dts/emev2.dtsi	2013-07-02 17:32:45.000000000 +0900
@@ -46,6 +46,12 @@
 		      <0xe0020000 0x0100>;
 	};
 
+	pmu {
+		compatible = "arm,cortex-a9-pmu";
+		interrupts = <0 120 4>,
+			     <0 121 4>;
+	};
+
 	sti@e0180000 {
 		compatible = "renesas,em-sti";
 		reg = <0xe0180000 0x54>;
