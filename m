Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3LPMfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:35:30 -0500
Received: from smtp206.alice.it ([82.57.200.102]:63749 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab3LPMf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:35:29 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-kernel@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        David Herrmann <dh.herrmann@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] Input: fix typos in Documentation/input/gamepad.txt
Date: Mon, 16 Dec 2013 13:34:52 +0100
Message-Id: <1387197292-29909-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.8.5.1
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some typos and while at it also use "PS" as the name for the central
"HOME" button on Sony controllers, this is how Sony itself calls it.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 Documentation/input/gamepad.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/input/gamepad.txt b/Documentation/input/gamepad.txt
index 4be7f21..63c0256 100644
--- a/Documentation/input/gamepad.txt
+++ b/Documentation/input/gamepad.txt
@@ -71,7 +71,7 @@ features that you need, first. How each feature is mapped is described below.
 Legacy drivers often don't comply to these rules. As we cannot change them
 for backwards-compatibility reasons, you need to provide fixup mappings in
 user-space yourself. Some of them might also provide module-options that
-change the mappings so you can adivce users to set these.
+change the mappings so you can advice users to set these.
 
 All new gamepads are supposed to comply with this mapping. Please report any
 bugs, if they don't.
@@ -156,10 +156,10 @@ Menu-Pad:
                   BTN_START
   Many pads also have a third button which is branded or has a special symbol
   and meaning. Such buttons are mapped as BTN_MODE. Examples are the Nintendo
-  "HOME" button, the XBox "X"-button or Sony "P" button.
+  "HOME" button, the XBox "X"-button or Sony "PS" button.
 
 Rumble:
-  Rumble is adverticed as FF_RUMBLE.
+  Rumble is advertised as FF_RUMBLE.
 
 Motion-tracking:
   Motion-tracking is defined in ./Documentation/input/motion-tracking.txt and
-- 
1.8.5.1

