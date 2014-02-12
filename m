Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaBLHyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:54:36 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:50520 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaBLHye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:54:34 -0500
From: Laszlo Papp <lpapp@kde.org>
To: rob@landley.net
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laszlo Papp <lpapp@kde.org>
Subject: [PATCH RESEND] leds-gpio: fix a typo in the documentation
Date: Wed, 12 Feb 2014 07:54:09 +0000
Message-Id: <1392191649-21723-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.4
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
1.8.5.4

