Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3COUuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:50:20 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56880 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab3COUuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:50:12 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        netdev@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ARM: cubieboard: Enable ethernet (WEMAC) support in dts
Date: Fri, 15 Mar 2013 21:50:03 +0100
Message-Id: <1363380605-6577-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363380605-6577-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1363380605-6577-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Roese <sr@denx.de>

Signed-off-by: Stefan Roese <sr@denx.de>
---
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
index 88e2dc1..7a3872d 100644
--- a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
+++ b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
@@ -43,6 +43,12 @@
 		uart1: uart@01c28400 {
 			status = "okay";
 		};
+
+		wemac: ethernet@01c0b000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&wemac_pins_a>;
+			status = "okay";
+		};
 	};
 
 	leds {
-- 
1.7.10.4

