Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbbAHLEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 06:04:09 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:45554 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbbAHLEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 06:04:05 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, matthias.bgg@gmail.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        s.hauer@pengutronix.de
Subject: [PATCH v2 2/2] ARM: mediatek: dts: Add uart to Aquaris5
Date: Thu,  8 Jan 2015 12:03:44 +0100
Message-Id: <1420715024-27738-3-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420715024-27738-1-git-send-email-matthias.bgg@gmail.com>
References: <1420715024-27738-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables uart port for the Aquaris5 mobile phone.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 arch/arm/boot/dts/mt6589-aquaris5.dts | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/mt6589-aquaris5.dts b/arch/arm/boot/dts/mt6589-aquaris5.dts
index 0da0470..594a6f3 100644
--- a/arch/arm/boot/dts/mt6589-aquaris5.dts
+++ b/arch/arm/boot/dts/mt6589-aquaris5.dts
@@ -21,10 +21,20 @@
 	compatible = "mundoreader,bq-aquaris5", "mediatek,mt6589";
 
 	chosen {
-		bootargs = "earlyprintk";
+		bootargs = "console=ttyS0,921600n8 earlyprintk";
+		stdout-path = &uart0;
 	};
 
 	memory {
 		reg = <0x80000000 0x40000000>;
 	};
+
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&uart3 {
+	status = "okay";
 };
-- 
1.9.1

