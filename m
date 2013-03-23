Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3CWWbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 18:31:33 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:42305 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3CWWap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 18:30:45 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        netdev@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Alejandro Mery <amery@geeks.cl>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ARM: sun4i: Add muxing options for the ethernet controller
Date: Sat, 23 Mar 2013 23:30:12 +0100
Message-Id: <1364077814-2233-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364077814-2233-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1364077814-2233-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EMAC only has one pinset available for muxing, so hopefully, we
cover all cases.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index a6bd36a..e5ef5e5 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -46,6 +46,17 @@
 				allwinner,drive = <0>;
 				allwinner,pull = <0>;
 			};
+
+			emac_pins_a: emac0@0 {
+				allwinner,pins = "PA0", "PA1", "PA2",
+						"PA3", "PA4", "PA5", "PA6",
+						"PA7", "PA8", "PA9", "PA10",
+						"PA11", "PA12", "PA13", "PA14",
+						"PA15", "PA16";
+				allwinner,function = "wemac";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
 		};
 
 		emac: ethernet@01c0b000 {
-- 
1.7.10.4

