Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965731AbaKNQDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:03:38 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:36719 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965288AbaKNQDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:03:35 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>, devicetree@vger.kernel.org,
        linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/2] DT: i2c: Add more devices handled by the rtc-rs5c372 driver
Date: Fri, 14 Nov 2014 17:03:30 +0100
Message-Id: <1415981011-13423-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows checkpatch to validate more DTSes.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/i2c/trivial-devices.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index fbde415078e6845c..7a2bbea61b70b942 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -74,7 +74,12 @@ ovti,ov5642		OV5642: Color CMOS QSXGA (5-megapixel) Image Sensor with OmniBSI an
 pericom,pt7c4338	Real-time Clock Module
 plx,pex8648		48-Lane, 12-Port PCI Express Gen 2 (5.0 GT/s) Switch
 ramtron,24c64		i2c serial eeprom  (24cxx)
+ricoh,r2025sd		I2C bus SERIAL INTERFACE REAL-TIME CLOCK IC
+ricoh,r2221tl		I2C bus SERIAL INTERFACE REAL-TIME CLOCK IC
 ricoh,rs5c372a		I2C bus SERIAL INTERFACE REAL-TIME CLOCK IC
+ricoh,rs5c372b		I2C bus SERIAL INTERFACE REAL-TIME CLOCK IC
+ricoh,rv5c386		I2C bus SERIAL INTERFACE REAL-TIME CLOCK IC
+ricoh,rv5c387a		I2C bus SERIAL INTERFACE REAL-TIME CLOCK IC
 samsung,24ad0xd1	S524AD0XF1 (128K/256K-bit Serial EEPROM for Low Power)
 sii,s35390a		2-wire CMOS real-time clock
 st-micro,24c256		i2c serial eeprom  (24cxx)
-- 
1.9.1

