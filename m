Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3JVM4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:56:24 -0400
Received: from ring0.de ([91.143.88.219]:36121 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab3JVM4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:56:21 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCH 1/2] Documentation: DTS: bq27xxx are trivial i2c devices
Date: Tue, 22 Oct 2013 14:56:16 +0200
Message-Id: <1382446577-28270-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add all chips supported by the bq27xxx driver to the list
of trivial i2c devices.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 Documentation/devicetree/bindings/i2c/trivial-devices.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index ad6a738..d3a29ce 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -58,6 +58,9 @@ stm,m41t00		Serial Access TIMEKEEPER
 stm,m41t62		Serial real-time clock (RTC) with alarm
 stm,m41t80		M41T80 - SERIAL ACCESS RTC WITH ALARMS
 taos,tsl2550		Ambient Light Sensor with SMBUS/Two Wire Serial Interface
-ti,tsc2003		I2C Touch-Screen Controller
+ti,bq27200		Battery Monitor
+ti,bq27500		Battery Monitor
+ti,bq27425		Battery Monitor
 ti,tmp102		Low Power Digital Temperature Sensor with SMBUS/Two Wire Serial Interface
 ti,tmp275		Digital Temperature Sensor
+ti,tsc2003		I2C Touch-Screen Controller
-- 
1.8.4.rc3

