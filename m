Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbbAQLyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 06:54:12 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60682 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbAQLyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 06:54:11 -0500
From: Shailendra Verma <shailendra.capricorn@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Shailendra Verma <shailendra.capricorn@gmail.com>
Subject: [PATCH 8/9] Fixed indentation violation in switch statement : Aligned the "switch" and its subordinate "case" labels in the same column instead of "double-intending" the "case" labels.
Date: Sat, 17 Jan 2015 17:23:45 +0530
Message-Id: <1421495625-21558-1-git-send-email-shailendra.capricorn@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Shailendra Verma <shailendra.capricorn@gmail.com>
---
 drivers/input/evdev.c    |   30 ++++++++++++++++++++----------
 drivers/input/mousedev.c |   18 ++++++++++++------
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 18d4b2c..85ee594 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -667,16 +667,26 @@ static int handle_eviocgbit(struct input_dev *dev,
 
 	switch (type) {
 
-	case      0: bits = dev->evbit;  len = EV_MAX;  break;
-	case EV_KEY: bits = dev->keybit; len = KEY_MAX; break;
-	case EV_REL: bits = dev->relbit; len = REL_MAX; break;
-	case EV_ABS: bits = dev->absbit; len = ABS_MAX; break;
-	case EV_MSC: bits = dev->mscbit; len = MSC_MAX; break;
-	case EV_LED: bits = dev->ledbit; len = LED_MAX; break;
-	case EV_SND: bits = dev->sndbit; len = SND_MAX; break;
-	case EV_FF:  bits = dev->ffbit;  len = FF_MAX;  break;
-	case EV_SW:  bits = dev->swbit;  len = SW_MAX;  break;
-	default: return -EINVAL;
+	case      0:
+		bits = dev->evbit;  len = EV_MAX;  break;
+	case EV_KEY:
+		bits = dev->keybit; len = KEY_MAX; break;
+	case EV_REL:
+		bits = dev->relbit; len = REL_MAX; break;
+	case EV_ABS:
+		bits = dev->absbit; len = ABS_MAX; break;
+	case EV_MSC:
+		bits = dev->mscbit; len = MSC_MAX; break;
+	case EV_LED:
+		bits = dev->ledbit; len = LED_MAX; break;
+	case EV_SND:
+		bits = dev->sndbit; len = SND_MAX; break;
+	case EV_FF:
+		bits = dev->ffbit;  len = FF_MAX;  break;
+	case EV_SW:
+		bits = dev->swbit;  len = SW_MAX;  break;
+	default:
+		return -EINVAL;
 	}
 
 	return bits_to_user(bits, len, size, p, compat_mode);
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index b604564..a9857dd 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -230,25 +230,31 @@ static void mousedev_key_event(struct mousedev *mousedev,
 
 	case BTN_TOUCH:
 	case BTN_0:
-	case BTN_LEFT:		index = 0; break;
+	case BTN_LEFT:
+		index = 0; break;
 
 	case BTN_STYLUS:
 	case BTN_1:
-	case BTN_RIGHT:		index = 1; break;
+	case BTN_RIGHT:
+		index = 1; break;
 
 	case BTN_2:
 	case BTN_FORWARD:
 	case BTN_STYLUS2:
-	case BTN_MIDDLE:	index = 2; break;
+	case BTN_MIDDLE:
+		index = 2; break;
 
 	case BTN_3:
 	case BTN_BACK:
-	case BTN_SIDE:		index = 3; break;
+	case BTN_SIDE:
+		index = 3; break;
 
 	case BTN_4:
-	case BTN_EXTRA:		index = 4; break;
+	case BTN_EXTRA:
+		index = 4; break;
 
-	default:		return;
+	default:
+		return;
 	}
 
 	if (value) {
-- 
1.7.9.5

