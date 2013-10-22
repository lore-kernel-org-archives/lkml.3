Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab3JVWwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:52:22 -0400
Received: from ring0.de ([91.143.88.219]:38671 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab3JVWuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:50:23 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCH 14/14] DTS: TWL4030: Add power button support
Date: Wed, 23 Oct 2013 00:49:43 +0200
Message-Id: <1382482183-14426-15-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382482183-14426-1-git-send-email-sre@debian.org>
References: <1382482183-14426-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable support for the power button.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 arch/arm/boot/dts/twl4030.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/twl4030.dtsi b/arch/arm/boot/dts/twl4030.dtsi
index cb5afcd..af7fa40 100644
--- a/arch/arm/boot/dts/twl4030.dtsi
+++ b/arch/arm/boot/dts/twl4030.dtsi
@@ -133,4 +133,9 @@
 		compatible = "ti,twl4030-pwmled";
 		#pwm-cells = <2>;
 	};
+
+	twl_pwrbutton: pwrbutton {
+		compatible = "ti,twl4030-pwrbutton";
+		interrupts = <8>;
+	};
 };
-- 
1.8.4.rc3

