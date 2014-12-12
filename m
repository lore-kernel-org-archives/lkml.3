Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934754AbaLLSca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:32:30 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35262 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933905AbaLLSc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:32:26 -0500
From: VishnuPatekar <vishnupatekar0510@gmail.com>
To: linux-input@vger.kernel.org, maxime.ripard@free-electrons.com,
        dmitry.torokhov@gmail.com, hdegoede@redhat.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, grant.likely@linaro.org,
        benh@kernel.crashing.org, msalter@redhat.com, ralf@linux-mips.org,
        jdelvare@suse.de, VishnuPatekar <vishnupatekar0510@gmail.com>
Subject: [PATCHv3 5/5] ARM: sunxi: dts: Add note ps2 pins conflict with hdmi
Date: Fri, 12 Dec 2014 23:55:48 +0530
Message-Id: <1418408748-9797-6-git-send-email-vishnupatekar0510@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418408748-9797-1-git-send-email-vishnupatekar0510@gmail.com>
References: <1418408748-9797-1-git-send-email-vishnupatekar0510@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Please note that ps20 pins conflict with HDMI on Lime2 Board
so, by deault ps20 and ps21 are disabled for Lime2 Board.
There is no on board ps2 connector and these pins can be used
for different purpose.

Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
---
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
index ed364d5..951b615 100644
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
@@ -112,7 +112,11 @@
 			pinctrl-0 = <&uart0_pins_a>;
 			status = "okay";
 		};
-
+
+		/* PS2 0 and PS2 1 are disabled by default; Please note that
+		ps20 pins conflict with HDMI on Lime2 Board
+		*/
+
 		i2c0: i2c@01c2ac00 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&i2c0_pins_a>;
-- 
1.7.9.5

