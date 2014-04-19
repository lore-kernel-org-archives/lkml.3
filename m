Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaDSPNM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 11:13:12 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:48159 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaDSPNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 11:13:10 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH] ARM: dts: twl4030: Add twl4030-madc node
Date: Sat, 19 Apr 2014 17:12:53 +0200
Message-Id: <1397920373-12073-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add madc node to twl4030 so DT boards can use it.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/twl4030.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/twl4030.dtsi b/arch/arm/boot/dts/twl4030.dtsi
index 86cfc7d..36ae916 100644
--- a/arch/arm/boot/dts/twl4030.dtsi
+++ b/arch/arm/boot/dts/twl4030.dtsi
@@ -152,4 +152,10 @@
 		keypad,num-rows = <8>;
 		keypad,num-columns = <8>;
 	};
+
+	twl_madc: madc {
+		compatible = "ti,twl4030-madc";
+		interrupts = <3>;
+		#io-channel-cells = <1>;
+	};
 };
-- 
1.8.3.2

