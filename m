Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab3COUGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:06:46 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56679 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab3COUGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:06:38 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] ARM: sunxi: dt: Use clocks property instead of clock-frequency for the UARTs
Date: Fri, 15 Mar 2013 21:06:24 +0100
Message-Id: <1363377988-4966-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363377988-4966-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1363377988-4966-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will be especially useful when we will have the clock definitions in
the device tree.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Emilio López <emilio@elopez.com.ar>
Tested-by: Emilio López <emilio@elopez.com.ar>
---
 arch/arm/boot/dts/sunxi.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sunxi.dtsi b/arch/arm/boot/dts/sunxi.dtsi
index 8b36abe..791c02a 100644
--- a/arch/arm/boot/dts/sunxi.dtsi
+++ b/arch/arm/boot/dts/sunxi.dtsi
@@ -65,7 +65,7 @@
 			interrupts = <1>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clock-frequency = <24000000>;
+			clocks = <&osc>;
 			status = "disabled";
 		};
 
@@ -75,7 +75,7 @@
 			interrupts = <2>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clock-frequency = <24000000>;
+			clocks = <&osc>;
 			status = "disabled";
 		};
 	};
-- 
1.7.10.4

