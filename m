Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965909AbaFSV4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:56:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:55850 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331AbaFSV4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:56:32 -0400
Message-Id: <20140619215557.784621009@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:56:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Viresh Kumar <viresh.linux@gmail.com>, spear-devel@list.st.com
Subject: [patch 1/2] dts: spear: Fix sdhci compatible
References: <20140619215347.139324048@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=spear-dts-fix-sdhci-compatible.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it match the bindings and the implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/boot/dts/spear320.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/arm/boot/dts/spear320.dtsi
===================================================================
--- linux.orig/arch/arm/boot/dts/spear320.dtsi
+++ linux/arch/arm/boot/dts/spear320.dtsi
@@ -48,7 +48,7 @@
 		};
 
 		sdhci@70000000 {
-			compatible = "st,sdhci-spear";
+			compatible = "st,spear300-sdhci";
 			reg = <0x70000000 0x100>;
 			interrupts = <10>;
 			interrupt-parent = <&shirq>;


