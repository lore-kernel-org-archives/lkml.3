Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaBESI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:08:26 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:43051 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaBESIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:08:24 -0500
From: Laszlo Papp <lpapp@kde.org>
To: rob@landley.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laszlo Papp <lpapp@kde.org>
Subject: [PATCH] leds-gpio: fix a typo in the documentation
Date: Wed,  5 Feb 2014 18:02:45 +0000
Message-Id: <1391623365-929-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 Documentation/devicetree/bindings/leds/leds-gpio.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/leds/leds-gpio.txt b/Documentation/devicetree/bindings/leds/leds-gpio.txt
index df1b308..00e94fe 100644
--- a/Documentation/devicetree/bindings/leds/leds-gpio.txt
+++ b/Documentation/devicetree/bindings/leds/leds-gpio.txt
@@ -16,7 +16,7 @@ LED sub-node properties:
   see Documentation/devicetree/bindings/leds/common.txt
 - default-state:  (optional) The initial state of the LED.  Valid
   values are "on", "off", and "keep".  If the LED is already on or off
-  and the default-state property is set the to same value, then no
+  and the default-state property is set to the same value, then no
   glitch should be produced where the LED momentarily turns off (or
   on).  The "keep" setting will keep the LED at whatever its current
   state is, without producing a glitch.  The default is off if this
-- 
1.8.5.3

