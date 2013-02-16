Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3BPLiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 06:38:46 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33024 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab3BPLim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 06:38:42 -0500
From: Anil Kumar <anilk4.v@gmail.com>
To: devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, b-cousson@ti.com, tony@atomide.com,
        grant.likely@secretlab.ca, zonque@gmail.com, thomas@tomweber.eu,
        anilk4.v@gmail.com
Subject: [PATCH 1/2] ARM: dts: omap3: Add gpmc node
Date: Sat, 16 Feb 2013 17:08:27 +0530
Message-Id: <1361014708-1659-2-git-send-email-anilk4.v@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1361014708-1659-1-git-send-email-anilk4.v@gmail.com>
References: <1361014708-1659-1-git-send-email-anilk4.v@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpmc DT node.

Signed-off-by: Anil Kumar <anilk4.v@gmail.com>
---
:100644 100644 1acc261... 9f36531... M	arch/arm/boot/dts/omap3.dtsi
 arch/arm/boot/dts/omap3.dtsi |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 1acc261..9f36531 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -397,5 +397,16 @@
 			ti,timer-alwon;
 			ti,timer-secure;
 		};
+
+		gpmc: gpmc@6e000000 {
+			compatible = "ti,omap3430-gpmc";
+			ti,hwmods = "gpmc";
+			reg = <0x6e000000 0x1000000>;
+			interrupts = <20>;
+			gpmc,num-cs = <8>;
+			gpmc,num-waitpins = <4>;
+			#address-cells = <2>;
+			#size-cells = <1>;
+		};
 	};
 };
-- 
1.7.0.4

