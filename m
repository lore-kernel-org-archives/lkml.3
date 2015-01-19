Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbbASLBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:01:51 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:57420 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbbASLBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:01:50 -0500
From: Stefan Wahren <stefan.wahren@i2se.com>
To: swarren@wwwdotorg.org, lee@kernel.org, linux@arm.linux.org.uk,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Subject: [PATCH 2/4 V2] dt-bindings: Add root properties for Raspberry Pi
Date: Mon, 19 Jan 2015 11:00:31 +0000
Message-Id: <1421665231-28221-1-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 1.7.9.5
X-Provags-ID: V03:K0:CaR4Gxml29FydEmLjqWP4jbe0Zg0doo/+ip9tFaxp82OQo6mC7i
 ByiC9zN1vM6/XzSebsjwh0wbIWXcOkWZnL85hNm+w3WvX4K14aQ5KiPdS/GZ1OTMlTOZt3R
 ghA3fN+gZDjxqJSKC5RXYSEh+q+BiSYDh6+JcYZBYt1tarUJafomYE/nR3i0Og2yPS1d59c
 4HPzUgQn6dUsM1TL2zLww==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds root compatible properties for the following boards:
- Raspberry Pi Model A
- Raspberry Pi Model A+
- Raspberry Pi Model B
- Raspberry Pi Model B (no P5)
- Raspberry Pi Model B rev2
- Raspberry Pi Model B+
- Raspberry Pi Compute Module

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---

Changes in V2:
- add all currently known Raspberry Pi boards as suggested by
  Stephen Warren

 Documentation/devicetree/bindings/arm/bcm2835.txt |   31 +++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/bcm2835.txt b/Documentation/devicetree/bindings/arm/bcm2835.txt
index ac68348..c78576b 100644
--- a/Documentation/devicetree/bindings/arm/bcm2835.txt
+++ b/Documentation/devicetree/bindings/arm/bcm2835.txt
@@ -1,8 +1,35 @@
 Broadcom BCM2835 device tree bindings
 -------------------------------------------
 
-Boards with the BCM2835 SoC shall have the following properties:
+Raspberry Pi Model A
+Required root node properties:
+compatible = "raspberrypi,model-a", "brcm,bcm2835";
 
-Required root node property:
+Raspberry Pi Model A+
+Required root node properties:
+compatible = "raspberrypi,model-a-plus", "brcm,bcm2835";
 
+Raspberry Pi Model B
+Required root node properties:
+compatible = "raspberrypi,model-b", "brcm,bcm2835";
+
+Raspberry Pi Model B (no P5)
+early model B with I2C0 rather than I2C1 routed to the expansion header
+Required root node properties:
+compatible = "raspberrypi,model-b-i2c0", "brcm,bcm2835";
+
+Raspberry Pi Model B rev2
+Required root node properties:
+compatible = "raspberrypi,model-b-rev2", "brcm,bcm2835";
+
+Raspberry Pi Model B+
+Required root node properties:
+compatible = "raspberrypi,model-b-plus", "brcm,bcm2835";
+
+Raspberry Pi Compute Module
+Required root node properties:
+compatible = "raspberrypi,compute-module", "brcm,bcm2835";
+
+Generic BCM2835 board
+Required root node properties:
 compatible = "brcm,bcm2835";
-- 
1.7.9.5

