Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaKJSzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:55:43 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:53919 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaKJSzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:55:37 -0500
From: Roman Byshko <rbyshko@gmail.com>
To: linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v2 5/5] ARM: dts: sun7i: Cubietruck: add power supply regulator for USB OTG VBUS
Date: Mon, 10 Nov 2014 19:55:10 +0100
Message-Id: <75c850ce9a46f86bd746205916bbdcae2cf63756.1415645258.git.rbyshko@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1415645258.git.rbyshko@gmail.com>
References: <cover.1415645258.git.rbyshko@gmail.com>
In-Reply-To: <cover.1415645258.git.rbyshko@gmail.com>
References: <cover.1415645258.git.rbyshko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roman Byshko <rbyshko@gmail.com>
---
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
index 1682307..a281d25 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
@@ -40,6 +40,7 @@
 		};
 
 		usbphy: phy@01c13400 {
+			usb0_vbus-supply = <&reg_usb0_vbus>;
 			usb1_vbus-supply = <&reg_usb1_vbus>;
 			usb2_vbus-supply = <&reg_usb2_vbus>;
 			status = "okay";
-- 
2.1.2

