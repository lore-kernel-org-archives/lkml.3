Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920AbaCSN3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:29:54 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:50231 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbaCSN3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:29:52 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 3/5] ARM: dts: tx53: fix LVDS display mappings
Date: Wed, 19 Mar 2014 14:28:39 +0100
Message-Id: <1395235721-13847-3-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395235721-13847-1-git-send-email-LW@KARO-electronics.de>
References: <1395235721-13847-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data-mapping and data-width settings were opposite of what the
display requires. Interestingly, these settings nevertheless produced
correct results.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 arch/arm/boot/dts/imx53-tx53-x13x.dts |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx53-tx53-x13x.dts b/arch/arm/boot/dts/imx53-tx53-x13x.dts
index cd3476b..26b918e 100644
--- a/arch/arm/boot/dts/imx53-tx53-x13x.dts
+++ b/arch/arm/boot/dts/imx53-tx53-x13x.dts
@@ -181,8 +181,8 @@
 	status = "okay";
 
 	lvds0: lvds-channel@0 {
-		fsl,data-mapping = "jeida";
-		fsl,data-width = <24>;
+		fsl,data-mapping = "spwg";
+		fsl,data-width = <18>;
 		status = "okay";
 
 		display-timings {
@@ -206,8 +206,8 @@
 	};
 
 	lvds1: lvds-channel@1 {
-		fsl,data-mapping = "jeida";
-		fsl,data-width = <24>;
+		fsl,data-mapping = "spwg";
+		fsl,data-width = <18>;
 		status = "okay";
 
 		display-timings {
-- 
1.7.10.4

