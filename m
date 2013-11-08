Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab3KHWyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 17:54:23 -0500
Received: from ring0.de ([91.143.88.219]:60430 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758434Ab3KHWyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 17:54:18 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Kumar Gala <galak@codeaurora.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCH] Documentation: dt: matrix-keymap: Add linux,keypad-no-autorepeat
Date: Fri,  8 Nov 2013 23:54:10 +0100
Message-Id: <1383951250-2050-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for linux,keypad-no-autorepeat, which
is supported by most matrix-keymap implementations.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 Documentation/devicetree/bindings/input/matrix-keymap.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/input/matrix-keymap.txt b/Documentation/devicetree/bindings/input/matrix-keymap.txt
index c54919f..e87de50 100644
--- a/Documentation/devicetree/bindings/input/matrix-keymap.txt
+++ b/Documentation/devicetree/bindings/input/matrix-keymap.txt
@@ -14,6 +14,7 @@ drivers will use fixed values for these.
 - keypad,num-rows: Number of row lines connected to the keypad controller.
 - keypad,num-columns: Number of column lines connected to the keypad
   controller.
+- linux,keypad-no-autorepeat: Do not enable autorepeat feature.
 
 Some users of this binding might choose to specify secondary keymaps for
 cases where there is a modifier key such as a Fn key. Proposed names
-- 
1.8.4.rc3

