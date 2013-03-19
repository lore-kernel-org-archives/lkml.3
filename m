Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab3CSKfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:35:50 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:42789 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab3CSKfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:35:47 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-serial@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] ARM: sunxi: dt: Add uart3 dt node
Date: Tue, 19 Mar 2013 11:35:14 +0100
Message-Id: <1363689316-7847-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363689316-7847-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1363689316-7847-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both A10 and A13 Allwinner SoCs have a Synopsys APB uart3 device
available, so add it to the sunxi.dtsi file

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Emilio López <emilio@elopez.com.ar>
---
 arch/arm/boot/dts/sunxi.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sunxi.dtsi b/arch/arm/boot/dts/sunxi.dtsi
index cf53c43..a85030b 100644
--- a/arch/arm/boot/dts/sunxi.dtsi
+++ b/arch/arm/boot/dts/sunxi.dtsi
@@ -68,5 +68,15 @@
 			clocks = <&osc>;
 			status = "disabled";
 		};
+
+		uart3: serial@01c28c00 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28c00 0x400>;
+			interrupts = <4>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.10.4

