Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab3ARGlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 01:41:04 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41430 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3ARGk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 01:40:57 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <zonque@gmail.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 1/3] ARM: dts: AM33XX: Add ELM node
Date: Fri, 18 Jan 2013 12:11:33 +0530
Message-ID: <1358491295-4022-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358491295-4022-1-git-send-email-avinashphilip@ti.com>
References: <1358491295-4022-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Philip, Avinash" <avinashphilip@ti.com>

Add ELM data node to AM33XX device tree file.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index c2f14e8..eaef5e7 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -385,5 +385,13 @@
 				mac-address = [ 00 00 00 00 00 00 ];
 			};
 		};
+
+		elm: elm@48080000 {
+			compatible	= "ti,am33xx-elm";
+			reg = <0x48080000 0x2000>;
+			interrupts = <4>;
+			ti,hwmods = "elm";
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.9.5

