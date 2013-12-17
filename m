Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3LQPxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:53:10 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:60173 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3LQPt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:49:28 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-input@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-kernel@vger.kernel.org, input-tools@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 3/4] Input: remove ambigious gamepad comment
Date: Tue, 17 Dec 2013 16:48:53 +0100
Message-Id: <1387295334-1744-4-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
References: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If only a single trigger combination is present on a device, either can be
reported. If the side of the trigger (left/right) cannot be decided (eg.,
if it's centered), then choose any side. User-space automatically notices
that only a single trigger is reported and thus doesn't care how it is
reported.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 Documentation/input/gamepad.txt | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/input/gamepad.txt b/Documentation/input/gamepad.txt
index 31bb6a4..196dc42 100644
--- a/Documentation/input/gamepad.txt
+++ b/Documentation/input/gamepad.txt
@@ -138,8 +138,6 @@ Triggers:
   Upper trigger buttons are reported as BTN_TR or ABS_HAT1X (right) and BTN_TL
   or ABS_HAT1Y (left). Lower trigger buttons are reported as BTN_TR2 or
   ABS_HAT2X (right/ZR) and BTN_TL2 or ABS_HAT2Y (left/ZL).
-  If only one trigger-button combination is present (upper+lower), they are
-  reported as "right" triggers (BTN_TR/ABS_HAT1X).
     (ABS trigger values start at 0, pressure is reported as positive values)
 
 Menu-Pad:
-- 
1.8.5.1

