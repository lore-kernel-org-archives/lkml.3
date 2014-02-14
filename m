Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaBNNSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:18:01 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:37826 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaBNNR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:17:56 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 2/2] ARM: dts: twl4030: Add twl4030-madc node.
Date: Fri, 14 Feb 2014 14:17:41 +0100
Message-Id: <1392383861-14169-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392383861-14169-1-git-send-email-marek@goldelico.com>
References: <1392383861-14169-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/twl4030.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/twl4030.dtsi b/arch/arm/boot/dts/twl4030.dtsi
index 4217096..e6dec53 100644
--- a/arch/arm/boot/dts/twl4030.dtsi
+++ b/arch/arm/boot/dts/twl4030.dtsi
@@ -145,4 +145,9 @@
 		compatible = "ti,twl4030-pwrbutton";
 		interrupts = <8>;
 	};
+
+	twl_madc: madc {
+		compatible = "ti,twl4030-madc";
+		interrupts = <1>;
+	};
 };
-- 
1.8.3.2

