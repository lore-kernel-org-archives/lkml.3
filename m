Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161549Ab3DEMdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:33:22 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:38611 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161376Ab3DEMdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 08:33:21 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: cfa10036: Add touchscreen support to the CFA-10049
Date: Fri,  5 Apr 2013 14:33:02 +0200
Message-Id: <1365165182-29502-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10049.dts |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/imx28-cfa10049.dts b/arch/arm/boot/dts/imx28-cfa10049.dts
index b9dad4e..f16c1e2 100644
--- a/arch/arm/boot/dts/imx28-cfa10049.dts
+++ b/arch/arm/boot/dts/imx28-cfa10049.dts
@@ -192,6 +192,11 @@
 			usbphy1: usbphy@8007e000 {
 				status = "okay";
 			};
+
+			lradc@80050000 {
+				status = "okay";
+				fsl,lradc-touchscreen-wires = <4>;
+			};
 		};
 	};
 
-- 
1.7.10.4

