Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966174AbaFSV4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:56:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:55848 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965421AbaFSV4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:56:32 -0400
Message-Id: <20140619215557.875556819@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:56:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Viresh Kumar <viresh.linux@gmail.com>, spear-devel@list.st.com
Subject: [patch 2/2] dts: spear: Add missing i2c1 interrupt
References: <20140619215347.139324048@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=spear-dts-add-i2c1-interrupt.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/boot/dts/spear320.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/arch/arm/boot/dts/spear320.dtsi
===================================================================
--- linux.orig/arch/arm/boot/dts/spear320.dtsi
+++ linux/arch/arm/boot/dts/spear320.dtsi
@@ -123,6 +123,11 @@
 				status = "disabled";
 			};
 
+			i2c1: i2c@a7000000 {
+				interrupts = <21>;
+				interrupt-parent = <&shirq>;
+			};
+
 			gpiopinctrl: gpio@b3000000 {
 				compatible = "st,spear-plgpio";
 				reg = <0xb3000000 0x1000>;


