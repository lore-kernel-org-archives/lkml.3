Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936606AbaH1LB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:01:58 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60481 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936487AbaH1LB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:01:56 -0400
From: Gyungoh Yoo <gyungoh@gmail.com>
X-Google-Original-From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
To: rdunlap@infradead.org
Cc: jack.yoo@skyworksinc.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] Adding SKY81452 backlight document
Date: Thu, 28 Aug 2014 20:01:49 +0900
Message-Id: <1409223709-23671-1-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409222307-23225-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1409222307-23225-1-git-send-email-jack.yoo@skyworksinc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
split the patches

---
 Documentation/backlight/sky81452-backlight.txt | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/backlight/sky81452-backlight.txt

diff --git a/Documentation/backlight/sky81452-backlight.txt b/Documentation/backlight/sky81452-backlight.txt
new file mode 100644
index 0000000..39f2f8c
--- /dev/null
+++ b/Documentation/backlight/sky81452-backlight.txt
@@ -0,0 +1,26 @@
+backlight driver for sky81452
+==========================
+
+* Skyworks Solutions SKY81452 :
+  High-Efficiency, Six-Channel White LED Driver with Touch Panel Bias Supply
+
+Description
+-----------
+The SKY81452 is a highly integrated, high-efficiency LED backlight solution for
+tablets, notebook computers, monitors, and other portable devices.
+
+The SKY81452 supports Direct Pulse Width Modulation(DPWM) dimming and Analog
+Pulse Width Modulation (APWM). In the DPWM dimming mode, the output waveform
+follows the Pulse Width Modulation Input(PWMI) signal and the current level is
+set by I2C control and an external RSET resistor. In the APWM mode, the PWMI
+signal duty and the I2C brightness control signal are multiplied to control
+the output current level.
+
+The driver exports some additional attributes for SKY81452 backlight.
+- enable : Current sink channels. Bit0 is for channel 1, Bit1 is for channel 2
+	and Bit2 is for channel 3. In same way, Bit5 is for channel 6.
+	For example, if 5 is written to this attribute, channel 1 and
+	channel 3 are enabled.
+- open : Shows an open LED fault.
+- short : Shows an short LED fault.
+- fault : Shows information about over-current and over-temperature.
-- 
1.9.1

