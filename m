Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534AbaGWUxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:53:33 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:58389 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281AbaGWUxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:53:21 -0400
From: Brad Slayter <slayterkernel@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brad Slayter <slayterkernel@gmail.com>
Subject: [PATCH] hid: hid-apple: Fixed 2 spacing style issues
Date: Wed, 23 Jul 2014 15:47:07 -0500
Message-Id: <1406148427-4073-1-git-send-email-slayterkernel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a spacing issue in a struct def and a funcion call.

Signed-off-by: Brad Slayter <slayterkernel@gmail.com>
---
 drivers/hid/hid-apple.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index f822fd2..8e0a0a4 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -157,10 +157,10 @@ static const struct apple_key_translation apple_iso_keyboard[] = {
 };
 
 static const struct apple_key_translation swapped_option_cmd_keys[] = {
-	{ KEY_LEFTALT,	KEY_LEFTMETA },
-	{ KEY_LEFTMETA,	KEY_LEFTALT },
-	{ KEY_RIGHTALT,	KEY_RIGHTMETA },
-	{ KEY_RIGHTMETA,KEY_RIGHTALT },
+	{ KEY_LEFTALT,	 KEY_LEFTMETA },
+	{ KEY_LEFTMETA,	 KEY_LEFTALT },
+	{ KEY_RIGHTALT,	 KEY_RIGHTMETA },
+	{ KEY_RIGHTMETA, KEY_RIGHTALT },
 	{ }
 };
 
@@ -200,7 +200,7 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 		else
 			table = apple_fn_keys;
 
-		trans = apple_find_translation (table, usage->code);
+		trans = apple_find_translation(table, usage->code);
 
 		if (trans) {
 			if (test_bit(usage->code, asc->pressed_fn))
-- 
1.7.10.4

