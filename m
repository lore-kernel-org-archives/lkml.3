Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993Ab3HSOLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 10:11:10 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58707 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3HSOLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:11:09 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: rob@landley.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: rdunlap@infradead.org, trivial@kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] doc: Fix typo "is is" in Documentations
Date: Mon, 19 Aug 2013 23:10:46 +0900
Message-Id: <1376921446-24653-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3.2.g2c2b664
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix double words "is is" in Documentations.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/DocBook/media/v4l/vidioc-g-parm.xml | 4 ++--
 Documentation/fmc/carrier.txt                     | 2 +-
 Documentation/hwmon/submitting-patches            | 2 +-
 Documentation/mtd/nand_ecc.txt                    | 2 +-
 Documentation/sound/alsa/README.maya44            | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-parm.xml b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
index 9058224..f4e28e7 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
@@ -132,7 +132,7 @@ devices.</para>
 	  <row>
 	    <entry>&v4l2-fract;</entry>
 	    <entry><structfield>timeperframe</structfield></entry>
-	    <entry><para>This is is the desired period between
+	    <entry><para>This is the desired period between
 successive frames captured by the driver, in seconds. The
 field is intended to skip frames on the driver side, saving I/O
 bandwidth.</para><para>Applications store here the desired frame
@@ -193,7 +193,7 @@ applications must set the array to zero.</entry>
 	  <row>
 	    <entry>&v4l2-fract;</entry>
 	    <entry><structfield>timeperframe</structfield></entry>
-	    <entry>This is is the desired period between
+	    <entry>This is the desired period between
 successive frames output by the driver, in seconds.</entry>
 	  </row>
 	  <row>
diff --git a/Documentation/fmc/carrier.txt b/Documentation/fmc/carrier.txt
index 173f6d6..5e4f1dd 100644
--- a/Documentation/fmc/carrier.txt
+++ b/Documentation/fmc/carrier.txt
@@ -213,7 +213,7 @@ The individual methods perform the following tasks:
      methods: for example the SPEC driver may define that its carrier
      I2C memory is seen at offset 1M and the internal SPI flash is seen
      at offset 16M.  This multiplexing of several flash memories in the
-     same address space is is carrier-specific and should only be used
+     same address space is carrier-specific and should only be used
      by a driver that has verified the `carrier_name' field.
 
 
diff --git a/Documentation/hwmon/submitting-patches b/Documentation/hwmon/submitting-patches
index 4628646..3d1bac3 100644
--- a/Documentation/hwmon/submitting-patches
+++ b/Documentation/hwmon/submitting-patches
@@ -1,7 +1,7 @@
 	How to Get Your Patch Accepted Into the Hwmon Subsystem
 	-------------------------------------------------------
 
-This text is is a collection of suggestions for people writing patches or
+This text is a collection of suggestions for people writing patches or
 drivers for the hwmon subsystem. Following these suggestions will greatly
 increase the chances of your change being accepted.
 
diff --git a/Documentation/mtd/nand_ecc.txt b/Documentation/mtd/nand_ecc.txt
index 990efd7..e129b24 100644
--- a/Documentation/mtd/nand_ecc.txt
+++ b/Documentation/mtd/nand_ecc.txt
@@ -543,7 +543,7 @@ THe code within the for loop was changed to:
     }
 
 As you can see tmppar is used to accumulate the parity within a for
-iteration. In the last 3 statements is is added to par and, if needed,
+iteration. In the last 3 statements is added to par and, if needed,
 to rp12 and rp14.
 
 While making the changes I also found that I could exploit that tmppar
diff --git a/Documentation/sound/alsa/README.maya44 b/Documentation/sound/alsa/README.maya44
index 0e41576..67b2ea1 100644
--- a/Documentation/sound/alsa/README.maya44
+++ b/Documentation/sound/alsa/README.maya44
@@ -120,7 +120,7 @@ Mic Phantom+48V: switch for +48V phantom power for electrostatic microphones on
     Make sure this is not turned on while any other source is connected to input 1/2.
     It might damage the source and/or the maya44 card.
 
-Mic/Line input: if switch is is on, input jack 1/2 is microphone input (mono), otherwise line input (stereo).
+Mic/Line input: if switch is on, input jack 1/2 is microphone input (mono), otherwise line input (stereo).
 
 Bypass: analogue bypass from ADC input to output for channel 1+2. Same as "Monitor" in the windows driver.
 Bypass 1: same for channel 3+4.
-- 
1.8.4.rc3.2.g2c2b664

