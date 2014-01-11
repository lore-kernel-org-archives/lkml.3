Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026AbaAKVLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 16:11:31 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:33590 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaAKVL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 16:11:27 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com, neilb@suse.de,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH] ARM: dts: twl4030: Add power support.
Date: Sat, 11 Jan 2014 22:11:14 +0100
Message-Id: <1389474674-4179-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/twl4030.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/twl4030.dtsi b/arch/arm/boot/dts/twl4030.dtsi
index 4217096..21079e1 100644
--- a/arch/arm/boot/dts/twl4030.dtsi
+++ b/arch/arm/boot/dts/twl4030.dtsi
@@ -25,6 +25,10 @@
 		bci3v1-supply = <&vusb3v1>;
 	};
 
+	twl_power: power {
+		compatible = "ti,twl4030-power";
+	};
+
 	watchdog {
 		compatible = "ti,twl4030-wdt";
 	};
-- 
1.8.4.2

