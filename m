Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaKJSzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:55:35 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:46582 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaKJSzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:55:32 -0500
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
Subject: [PATCH v2 3/5] ARM: sun7i: dtsi: add support for usbphy0
Date: Mon, 10 Nov 2014 19:55:08 +0100
Message-Id: <ef8f31d5cf50014417bd08a326241ba01ec4cf03.1415645258.git.rbyshko@gmail.com>
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
 arch/arm/boot/dts/sun7i-a20.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 82097c9..f787ccb 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -552,8 +552,8 @@
 			reg-names = "phy_ctrl", "pmu1", "pmu2";
 			clocks = <&usb_clk 8>;
 			clock-names = "usb_phy";
-			resets = <&usb_clk 1>, <&usb_clk 2>;
-			reset-names = "usb1_reset", "usb2_reset";
+			resets = <&usb_clk 0>, <&usb_clk 1>, <&usb_clk 2>;
+			reset-names = "usb0_reset", "usb1_reset", "usb2_reset";
 			status = "disabled";
 		};
 
-- 
2.1.2

