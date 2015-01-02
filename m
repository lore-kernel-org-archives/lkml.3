Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbbABSsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:48:35 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54823 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbbABSsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:48:18 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, matthias.bgg@gmail.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] ARM: mediatek: dts: Add uart to Aquaris5
Date: Fri,  2 Jan 2015 19:48:05 +0100
Message-Id: <1420224485-11043-3-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420224485-11043-1-git-send-email-matthias.bgg@gmail.com>
References: <1420224485-11043-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables uart port for the Aquaris5 mobile phone.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 arch/arm/boot/dts/mt6589-aquaris5.dts | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/mt6589-aquaris5.dts b/arch/arm/boot/dts/mt6589-aquaris5.dts
index 0da0470..d5cbfda 100644
--- a/arch/arm/boot/dts/mt6589-aquaris5.dts
+++ b/arch/arm/boot/dts/mt6589-aquaris5.dts
@@ -21,10 +21,16 @@
 	compatible = "mundoreader,bq-aquaris5", "mediatek,mt6589";
 
 	chosen {
-		bootargs = "earlyprintk";
+		bootargs = "console=ttyS0,921600n8 earlyprintk";
 	};
 
 	memory {
 		reg = <0x80000000 0x40000000>;
 	};
+
+	soc {
+		uart0: serial@11006000 {
+			status = "okay";
+		};
+	};
 };
-- 
1.9.1

