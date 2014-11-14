Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965753AbaKNQDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:03:39 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:36726 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965601AbaKNQDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:03:35 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>, devicetree@vger.kernel.org,
        linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/2] DT: i2c: Add more devices handled by the adxl34x-i2c driver
Date: Fri, 14 Nov 2014 17:03:31 +0100
Message-Id: <1415981011-13423-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415981011-13423-1-git-send-email-geert+renesas@glider.be>
References: <1415981011-13423-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows checkpatch to validate more DTSes.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/i2c/trivial-devices.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index 7a2bbea61b70b942..e0beef4f8cff5cdf 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -17,6 +17,9 @@ adi,adt7473		+/-1C TDM Extended Temp Range I.C
 adi,adt7475		+/-1C TDM Extended Temp Range I.C
 adi,adt7476		+/-1C TDM Extended Temp Range I.C
 adi,adt7490		+/-1C TDM Extended Temp Range I.C
+adi,adxl345		Three-Axis Digital Accelerometer
+adi,adxl346		Three-Axis Digital Accelerometer
+adi,adxl34x		Three-Axis Digital Accelerometer
 at,24c08		i2c serial eeprom  (24cxx)
 atmel,24c00		i2c serial eeprom  (24cxx)
 atmel,24c01		i2c serial eeprom  (24cxx)
-- 
1.9.1

